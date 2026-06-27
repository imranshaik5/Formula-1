import asyncio
import json
import time
import signal
import sys
import os
import math
import random
from threading import Lock
from dataclasses import asdict
from typing import Optional

import aiohttp
from aiohttp import web

from config import WS_HOST, WS_PORT, BUFFER_FLUSH_INTERVAL
from live_client import LiveF1Client
from models import LiveDataSnapshot, LiveDriverPosition, LiveFastestLap, LiveSessionState

MOCK = os.getenv("MOCK", "0") == "1"


MOCK_DRIVERS = [
    (1, "Charles Leclerc", "LEC", "Ferrari"),
    (2, "Carlos Sainz", "SAI", "Ferrari"),
    (3, "Max Verstappen", "VER", "Red Bull"),
    (4, "Sergio Perez", "PER", "Red Bull"),
    (5, "Lando Norris", "NOR", "McLaren"),
    (6, "Oscar Piastri", "PIA", "McLaren"),
    (7, "Lewis Hamilton", "HAM", "Mercedes"),
    (8, "George Russell", "RUS", "Mercedes"),
    (9, "Fernando Alonso", "ALO", "Aston Martin"),
    (10, "Lance Stroll", "STR", "Aston Martin"),
    (11, "Pierre Gasly", "GAS", "Alpine"),
    (12, "Esteban Ocon", "OCO", "Alpine"),
    (13, "Yuki Tsunoda", "TSU", "Racing Bulls"),
    (14, "Daniel Ricciardo", "RIC", "Racing Bulls"),
    (15, "Alexander Albon", "ALB", "Williams"),
    (16, "Logan Sargeant", "SAR", "Williams"),
    (17, "Nico Hulkenberg", "HUL", "Haas"),
    (18, "Kevin Magnussen", "MAG", "Haas"),
    (19, "Zhou Guanyu", "ZHO", "Kick Sauber"),
    (20, "Valtteri Bottas", "BOT", "Kick Sauber"),
]

class LiveTimingServer:
    def __init__(self):
        self._livef1 = LiveF1Client()
        self._snapshot = LiveDataSnapshot()
        self._snapshot_lock = Lock()
        self._clients: set[web.WebSocketResponse] = set()
        self._clients_lock = Lock()
        self._mock_cycle = 0

    def _parse_position_data(self, topic: str, data: dict) -> None:
        with self._snapshot_lock:
            if topic == "Position.z" and isinstance(data, list):
                for entry in data:
                    dn = entry.get("DriverNumber") or entry.get("RacingNumber")
                    if dn is None:
                        continue
                    dn = int(dn)
                    pos = self._snapshot.positions.get(dn) or LiveDriverPosition(
                        driver_number=dn, position=0, status=""
                    )
                    pos.position = int(entry.get("Position", pos.position))
                    pos.status = entry.get("Status", pos.status)
                    pos.gap_to_front = entry.get("GapToFront", pos.gap_to_front)
                    pos.interval_to_ahead = entry.get("IntervalToAhead", pos.interval_to_ahead)
                    pos.lap = int(entry.get("Lap", pos.lap))
                    self._snapshot.positions[dn] = pos
                self._snapshot.timestamp = time.time()

            elif topic == "TimingData.z" and isinstance(data, dict):
                lines = data.get("Lines", {})
                for dn_str, line_data in lines.items():
                    try:
                        dn = int(dn_str)
                    except (ValueError, TypeError):
                        continue
                    pos = self._snapshot.positions.get(dn) or LiveDriverPosition(
                        driver_number=dn, position=0, status=""
                    )
                    pos.last_lap_time = line_data.get("LastLapTime", {}).get("Value", pos.last_lap_time)
                    pos.sector1 = line_data.get("Sector1Time", {}).get("Value", pos.sector1)
                    pos.sector2 = line_data.get("Sector2Time", {}).get("Value", pos.sector2)
                    pos.sector3 = line_data.get("Sector3Time", {}).get("Value", pos.sector3)
                    pos.speed_trap = line_data.get("SpeedTrap", {}).get("Value", pos.speed_trap)
                    pos.pit_stop_count = int(line_data.get("PitStopCount", pos.pit_stop_count))
                    pos.retired = line_data.get("Retired", False) if isinstance(line_data.get("Retired"), bool) else pos.retired
                    self._snapshot.positions[dn] = pos
                self._snapshot.timestamp = time.time()

            elif topic == "TimingAppData.z" and isinstance(data, dict):
                lines = data.get("Lines", {})
                for dn_str, line_data in lines.items():
                    try:
                        dn = int(dn_str)
                    except (ValueError, TypeError):
                        continue
                    pos = self._snapshot.positions.get(dn) or LiveDriverPosition(
                        driver_number=dn, position=0, status=""
                    )
                    pos.lap = int(line_data.get("NumberOfLaps", pos.lap))
                    pos.gap_to_front = line_data.get("GapToFront", pos.gap_to_front)
                    pos.interval_to_ahead = line_data.get("IntervalToAhead", pos.interval_to_ahead)
                    self._snapshot.positions[dn] = pos
                self._snapshot.timestamp = time.time()

            elif topic == "SessionInfo" and isinstance(data, dict):
                self._snapshot.session.session_status = data.get("Status", self._snapshot.session.session_status)
                self._snapshot.session.track_status = data.get("TrackStatus", self._snapshot.session.track_status)
                self._snapshot.session.lap_count = int(data.get("NumberOfLaps", self._snapshot.session.lap_count))
                self._snapshot.session.total_laps = int(data.get("TotalLaps", self._snapshot.session.total_laps))
                self._snapshot.session.weather = data.get("Weather", self._snapshot.session.weather)
                self._snapshot.timestamp = time.time()

            elif topic == "WeatherData.z" and isinstance(data, dict):
                self._snapshot.session.air_temp = data.get("AirTemp", self._snapshot.session.air_temp)
                self._snapshot.session.track_temp = data.get("TrackTemp", self._snapshot.session.track_temp)
                self._snapshot.session.wind_speed = data.get("WindSpeed", self._snapshot.session.wind_speed)
                self._snapshot.session.wind_direction = data.get("WindDirection", self._snapshot.session.wind_direction)
                self._snapshot.session.humidity = data.get("Humidity", self._snapshot.session.humidity)
                self._snapshot.timestamp = time.time()

    def _detect_fastest_lap(self) -> None:
        with self._snapshot_lock:
            best_time = float("inf")
            best_dn = None
            best_lap = 0
            for dn, pos in self._snapshot.positions.items():
                if pos.last_lap_time:
                    try:
                        t = self._parse_lap_time(pos.last_lap_time)
                        if t and t < best_time:
                            best_time = t
                            best_dn = dn
                            best_lap = pos.lap
                    except Exception:
                        pass
            if best_dn is not None:
                self._snapshot.fastest_lap = LiveFastestLap(
                    driver_number=best_dn,
                    lap=best_lap,
                    lap_time=self._snapshot.positions[best_dn].last_lap_time or "",
                )

    def _parse_lap_time(self, time_str: str) -> Optional[float]:
        try:
            parts = time_str.replace(".", ":").split(":")
            if len(parts) == 3:
                return int(parts[0]) * 60 + int(parts[1]) + float(parts[2]) / 1000
            elif len(parts) == 2:
                return int(parts[0]) * 60 + float(parts[1])
            return float(time_str)
        except (ValueError, IndexError):
            return None

    def _build_snapshot_json(self) -> dict:
        with self._snapshot_lock:
            sorted_positions = sorted(
                self._snapshot.positions.values(),
                key=lambda p: p.position if p.position > 0 else 999,
            )
            positions_json = []
            for pos in sorted_positions:
                positions_json.append({
                    "driverNumber": pos.driver_number,
                    "position": pos.position,
                    "status": pos.status,
                    "gapToFront": pos.gap_to_front,
                    "intervalToAhead": pos.interval_to_ahead,
                    "lap": pos.lap,
                    "lastLapTime": pos.last_lap_time,
                    "sector1": pos.sector1,
                    "sector2": pos.sector2,
                    "sector3": pos.sector3,
                    "speedTrap": pos.speed_trap,
                    "pitStopCount": pos.pit_stop_count,
                    "retired": pos.retired,
                })
            fl = self._snapshot.fastest_lap
            return {
                "type": "snapshot",
                "positions": positions_json,
                "fastestLap": {
                    "driverNumber": fl.driver_number,
                    "lap": fl.lap,
                    "lapTime": fl.lap_time,
                } | ({"sector1": fl.sector1} if fl.sector1 else {})
                  | ({"sector2": fl.sector2} if fl.sector2 else {})
                  | ({"sector3": fl.sector3} if fl.sector3 else {}) if fl else None,
                "session": {
                    "status": self._snapshot.session.session_status,
                    "trackStatus": self._snapshot.session.track_status,
                    "weather": self._snapshot.session.weather,
                    "airTemp": self._snapshot.session.air_temp,
                    "trackTemp": self._snapshot.session.track_temp,
                    "windSpeed": self._snapshot.session.wind_speed,
                    "windDirection": self._snapshot.session.wind_direction,
                    "humidity": self._snapshot.session.humidity,
                    "lapCount": self._snapshot.session.lap_count,
                    "totalLaps": self._snapshot.session.total_laps,
                },
                "timestamp": self._snapshot.timestamp,
            }

    def _generate_mock_snapshot(self):
        self._mock_cycle += 1
        cyc = self._mock_cycle
        n = len(MOCK_DRIVERS)

        base_lap = 85.0
        raw_times = {}
        for i, (num, name, code, team) in enumerate(MOCK_DRIVERS):
            variation = random.gauss(0, 2.5 * 0.3)
            perf = math.sin(cyc * 0.05 + i * 0.7) * 0.15
            raw_times[num] = max(72.0, base_lap + variation + perf)

        sorted_dns = sorted(raw_times.keys(), key=lambda dn: raw_times[dn])

        with self._snapshot_lock:
            self._snapshot = LiveDataSnapshot()
            best_time = float("inf")
            best_dn = None
            leader_gap = 0.0
            track_flags = ["1", "1", "1", "1", "1", "2", "1", "1", "1", "1"]
            track_idx = int((cyc // 30) % len(track_flags))

            for pos, dn in enumerate(sorted_dns, 1):
                gap_to_front = raw_times[dn] - raw_times[sorted_dns[0]]
                interval = gap_to_front - leader_gap if pos > 1 else 0.0
                leader_gap = gap_to_front
                lap = max(1, min(57, int(cyc * 0.3)))

                s1 = random.uniform(25.0, 28.0) + random.gauss(0, 0.3)
                s2 = random.uniform(30.0, 34.0) + random.gauss(0, 0.4)
                s3 = random.uniform(23.0, 26.0) + random.gauss(0, 0.25)
                lap_time = s1 + s2 + s3

                if lap_time < best_time:
                    best_time = lap_time
                    best_dn = dn

                def fmt(t):
                    m = int(t) // 60
                    s = t - m * 60
                    return f"{m}:{s:06.3f}"

                def gap_str(g):
                    if g <= 0:
                        return "—"
                    if g >= 60:
                        return f"+{int(g)//60}:{g%60:05.2f}"
                    return f"+{g:05.3f}"

                self._snapshot.positions[dn] = LiveDriverPosition(
                    driver_number=dn,
                    position=pos,
                    status=random.choice(["OnTrack", "OnTrack", "OnTrack", "OnTrack", "Pit"]),
                    gap_to_front=gap_str(gap_to_front),
                    interval_to_ahead=gap_str(interval),
                    lap=lap,
                    last_lap_time=fmt(lap_time),
                    sector1=fmt(s1),
                    sector2=fmt(s2),
                    sector3=fmt(s3),
                    speed_trap=f"{random.randint(290, 340)}",
                    pit_stop_count=random.choice([0, 0, 0, 1, 0, 0, 2]) if cyc > 20 else 0,
                    retired=False,
                )

            if best_dn:
                d = self._snapshot.positions[best_dn]
                self._snapshot.fastest_lap = LiveFastestLap(
                    driver_number=best_dn,
                    lap=d.lap,
                    lap_time=d.last_lap_time or "",
                    sector1=d.sector1,
                    sector2=d.sector2,
                    sector3=d.sector3,
                )

            self._snapshot.session = LiveSessionState(
                session_status="InProgress",
                track_status=track_flags[track_idx],
                weather="Dry",
                air_temp=round(24.0 + math.sin(cyc * 0.02) * 3, 1),
                track_temp=round(36.0 + math.sin(cyc * 0.015) * 4, 1),
                wind_speed=round(random.uniform(2.0, 8.0), 1),
                wind_direction=random.choice(["N", "NE", "E", "SE", "S", "SW", "W", "NW"]),
                humidity=random.randint(30, 60),
                lap_count=self._snapshot.positions[sorted_dns[0]].lap if sorted_dns else 0,
                total_laps=57,
            )
            self._snapshot.timestamp = time.time()

    async def _broadcast(self, message: str):
        dead: list[web.WebSocketResponse] = []
        with self._clients_lock:
            for ws in self._clients:
                try:
                    await ws.send_str(message)
                except Exception:
                    dead.append(ws)
            for ws in dead:
                self._clients.discard(ws)

    async def _flush_loop(self):
        while True:
            if MOCK:
                self._generate_mock_snapshot()
            else:
                raw_batch = self._livef1.get_data_batch()
                for record in raw_batch:
                    self._parse_position_data(record.get("topic", ""), record.get("data", {}))
                self._detect_fastest_lap()
            snapshot = self._build_snapshot_json()
            if snapshot["positions"] or snapshot["fastestLap"]:
                await self._broadcast(json.dumps(snapshot))
            await asyncio.sleep(BUFFER_FLUSH_INTERVAL)

    async def ws_handler(self, request: web.Request) -> web.WebSocketResponse:
        ws = web.WebSocketResponse(max_msg_size=256 * 1024)
        await ws.prepare(request)
        with self._clients_lock:
            self._clients.add(ws)
        print(f"[Server] Client connected. Total: {len(self._clients)}")
        try:
            snapshot = self._build_snapshot_json()
            if snapshot["positions"] or snapshot["fastestLap"]:
                await ws.send_str(json.dumps(snapshot))
            async for msg in ws:
                if msg.type == aiohttp.WSMsgType.ERROR:
                    print(f"[Server] WS error: {ws.exception()}")
                elif msg.type == aiohttp.WSMsgType.TEXT:
                    try:
                        cmd = json.loads(msg.data)
                        if cmd.get("action") == "ping":
                            await ws.send_str(json.dumps({"type": "pong"}))
                    except json.JSONDecodeError:
                        pass
        except Exception as e:
            print(f"[Server] WS handler error: {e}")
        finally:
            with self._clients_lock:
                self._clients.discard(ws)
            print(f"[Server] Client disconnected. Total: {len(self._clients)}")
        return ws

    async def health_handler(self, request: web.Request) -> web.Response:
        return web.json_response({
            "status": "ok",
            "clients": len(self._clients),
            "connected": self._livef1.is_connected if not MOCK else True,
            "drivers": len(self._snapshot.positions),
            "mock": MOCK,
        })

    async def start(self):
        if not MOCK:
            self._livef1.start()
        app = web.Application()
        app.router.add_get("/ws", self.ws_handler)
        app.router.add_get("/health", self.health_handler)
        runner = web.AppRunner(app)
        await runner.setup()
        site = web.TCPSite(runner, WS_HOST, WS_PORT)
        await site.start()
        mode = "MOCK" if MOCK else "LIVE (requires F1 TV subscription)"
        print(f"[Server] LiveF1 WebSocket server running on ws://{WS_HOST}:{WS_PORT}/ws [{mode}]")
        asyncio.create_task(self._flush_loop())
        return runner


async def main():
    server = LiveTimingServer()
    runner = await server.start()

    stop_event = asyncio.Event()

    def _signal_handler():
        stop_event.set()

    loop = asyncio.get_running_loop()
    for sig in (signal.SIGINT, signal.SIGTERM):
        try:
            loop.add_signal_handler(sig, _signal_handler)
        except NotImplementedError:
            pass

    await stop_event.wait()
    print("[Server] Shutting down...")
    await runner.cleanup()
    print("[Server] Goodbye.")


if __name__ == "__main__":
    asyncio.run(main())
