import random
import time
import math
from queue import Queue, Empty
from threading import Event
from dataclasses import dataclass, field, asdict
from typing import Optional

from models import LiveDataSnapshot, LiveDriverPosition, LiveFastestLap, LiveSessionState

MOCK_DRIVERS = [
    (1, 16, "Charles Leclerc", "LEC", "Ferrari"),
    (2, 55, "Carlos Sainz", "SAI", "Ferrari"),
    (3, 1, "Max Verstappen", "VER", "Red Bull"),
    (4, 11, "Sergio Perez", "PER", "Red Bull"),
    (5, 4, "Lando Norris", "NOR", "McLaren"),
    (6, 81, "Oscar Piastri", "PIA", "McLaren"),
    (7, 44, "Lewis Hamilton", "HAM", "Mercedes"),
    (8, 63, "George Russell", "RUS", "Mercedes"),
    (9, 14, "Fernando Alonso", "ALO", "Aston Martin"),
    (10, 18, "Lance Stroll", "STR", "Aston Martin"),
    (11, 10, "Pierre Gasly", "GAS", "Alpine"),
    (12, 31, "Esteban Ocon", "OCO", "Alpine"),
    (13, 22, "Yuki Tsunoda", "TSU", "Racing Bulls"),
    (14, 3, "Daniel Ricciardo", "RIC", "Racing Bulls"),
    (15, 23, "Alexander Albon", "ALB", "Williams"),
    (16, 2, "Logan Sargeant", "SAR", "Williams"),
    (17, 27, "Nico Hulkenberg", "HUL", "Haas"),
    (18, 20, "Kevin Magnussen", "MAG", "Haas"),
    (19, 24, "Zhou Guanyu", "ZHO", "Kick Sauber"),
    (20, 77, "Valtteri Bottas", "BOT", "Kick Sauber"),
]

LAP_TIME_MEAN = 85.0
LAP_TIME_STD = 2.5
BASE_TEMP = 24.0
TRACK_TEMP_OFFSET = 12.0
TOTAL_LAPS = 57
CYCLE_INTERVAL = 1.0


def _format_lap(seconds: float) -> str:
    mins = int(seconds) // 60
    secs = seconds - mins * 60
    return f"{mins}:{secs:06.3f}"


def _format_gap(seconds: float) -> str:
    if seconds < 0:
        return "—"
    if seconds >= 60:
        return f"+{int(seconds)//60}:{seconds%60:05.2f}"
    return f"+{seconds:05.3f}"


class MockLiveF1Client:
    def __init__(self):
        self._data_queue: Queue = Queue(maxsize=5000)
        self._running = Event()
        self._cycle = 0
        self._driver_data: dict[int, dict] = {}
        for si, dn, name, code, team in MOCK_DRIVERS:
            base_speed = random.gauss(1.0, 0.08)
            self._driver_data[dn] = {
                "index": si - 1,
                "name": name,
                "code": code,
                "team": team,
                "base_speed": base_speed,
                "consistency": random.uniform(0.3, 0.8),
                "last_lap_mean": LAP_TIME_MEAN / base_speed,
                "sectors": [
                    random.uniform(25.0, 28.0),
                    random.uniform(30.0, 34.0),
                    random.uniform(23.0, 26.0),
                ],
            }

    def start(self):
        self._running.set()

    def stop(self):
        self._running.clear()

    def get_data_batch(self, timeout: float = 0.01) -> list[dict]:
        batch = []
        try:
            while True:
                batch.append(self._data_queue.get_nowait())
        except Empty:
            pass
        return batch

    def tick(self) -> dict:
        self._cycle += 1
        cyc = self._cycle
        n = len(MOCK_DRIVERS)

        raw_speed = {}
        for si, dn, name, code, team in MOCK_DRIVERS:
            d = self._driver_data[dn]
            variation = random.gauss(0, LAP_TIME_STD * 0.3)
            perf_cycle = math.sin(cyc * 0.05 + d["index"] * 0.7) * 0.15
            lap_raw = d["last_lap_mean"] + variation + perf_cycle
            raw_speed[dn] = max(72.0, lap_raw)

        sorted_dns = sorted(raw_speed.keys(), key=lambda dn: raw_speed[dn])
        positions: list[tuple[int, int, float]] = []
        for pos, dn in enumerate(sorted_dns, 1):
            gap = raw_speed[dn] - raw_speed[sorted_dns[0]] if pos > 1 else 0.0
            gap = max(0.0, gap)
            positions.append((pos, dn, gap))

        snapshot = LiveDataSnapshot()
        leader_gap = 0.0
        for pos, dn, gap_to_front in positions:
            interval = gap_to_front - leader_gap if pos > 1 else 0.0
            leader_gap = gap_to_front
            d = self._driver_data[dn]
            lap = max(1, min(TOTAL_LAPS, int(cyc * 0.3 + d["index"] * 0.1)))

            s1 = d["sectors"][0] + random.gauss(0, 0.3)
            s2 = d["sectors"][1] + random.gauss(0, 0.4)
            s3 = d["sectors"][2] + random.gauss(0, 0.25)
            lap_time = s1 + s2 + s3

            snapshot.positions[dn] = LiveDriverPosition(
                driver_number=dn,
                position=pos,
                status="OnTrack" if random.random() > 0.02 else "Pit",
                gap_to_front=_format_gap(gap_to_front),
                interval_to_ahead=_format_gap(interval),
                lap=lap,
                last_lap_time=_format_lap(lap_time),
                sector1=_format_lap(s1),
                sector2=_format_lap(s2),
                sector3=_format_lap(s3),
                speed_trap=f"{random.randint(290, 340)}",
                pit_stop_count=random.choice([0, 0, 0, 1, 0, 0, 2]) if cyc > 20 else 0,
                retired=False,
            )

        best_dn = sorted_dns[0]
        best_lap_time = raw_speed[best_dn]
        for pos, dn, gap in positions:
            if raw_speed[dn] < best_lap_time:
                best_lap_time = raw_speed[dn]
                best_dn = dn

        d = self._driver_data[best_dn]
        s1 = d["sectors"][0] + random.gauss(0, 0.2)
        s2 = d["sectors"][1] + random.gauss(0, 0.3)
        s3 = d["sectors"][2] + random.gauss(0, 0.2)
        fl_time = s1 + s2 + s3
        snapshot.fastest_lap = LiveFastestLap(
            driver_number=best_dn,
            lap=snapshot.positions[best_dn].lap,
            lap_time=_format_lap(fl_time),
            sector1=_format_lap(s1),
            sector2=_format_lap(s2),
            sector3=_format_lap(s3),
        )

        track_statuses = ["1", "1", "1", "1", "1", "2", "1", "1", "1", "1"]
        track_idx = int((cyc // 30) % len(track_statuses))
        snapshot.session = LiveSessionState(
            session_status="InProgress",
            track_status=track_statuses[track_idx],
            weather="Dry",
            air_temp=round(BASE_TEMP + math.sin(cyc * 0.02) * 3, 1),
            track_temp=round(BASE_TEMP + TRACK_TEMP_OFFSET + math.sin(cyc * 0.015) * 4, 1),
            wind_speed=round(random.uniform(2.0, 8.0), 1),
            wind_direction=random.choice(["N", "NE", "E", "SE", "S", "SW", "W", "NW"]),
            humidity=random.randint(30, 60),
            lap_count=snapshot.positions[sorted_dns[0]].lap if sorted_dns else 0,
            total_laps=TOTAL_LAPS,
        )

        snapshot.timestamp = time.time()

        if sorted_dns and any(p.position == 1 for _, p in snapshot.positions.items()):
            return asdict(snapshot) if hasattr(snapshot, '__dataclass_fields__') else snapshot
        return snapshot

    @property
    def is_connected(self) -> bool:
        return self._running.is_set()
