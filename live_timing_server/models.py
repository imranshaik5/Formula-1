from dataclasses import dataclass, field
from typing import Any, Optional


@dataclass
class LiveDriverPosition:
    driver_number: int
    position: int
    status: str
    gap_to_front: Optional[str] = None
    interval_to_ahead: Optional[str] = None
    lap: int = 0
    last_lap_time: Optional[str] = None
    sector1: Optional[str] = None
    sector2: Optional[str] = None
    sector3: Optional[str] = None
    speed_trap: Optional[str] = None
    pit_stop_count: int = 0
    retired: bool = False


@dataclass
class LiveSessionState:
    session_status: str = ""
    track_status: str = ""
    weather: str = ""
    air_temp: Optional[float] = None
    track_temp: Optional[float] = None
    wind_speed: Optional[float] = None
    wind_direction: Optional[str] = None
    humidity: Optional[int] = None
    lap_count: int = 0
    total_laps: int = 0


@dataclass
class LiveFastestLap:
    driver_number: int
    lap: int
    lap_time: str
    sector1: Optional[str] = None
    sector2: Optional[str] = None
    sector3: Optional[str] = None


@dataclass
class LiveDataSnapshot:
    positions: dict[int, LiveDriverPosition] = field(default_factory=dict)
    fastest_lap: Optional[LiveFastestLap] = None
    session: LiveSessionState = field(default_factory=LiveSessionState)
    timestamp: float = 0.0
