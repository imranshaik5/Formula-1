import os

WS_HOST = os.getenv("LIVEF1_WS_HOST", "127.0.0.1")
WS_PORT = int(os.getenv("LIVEF1_WS_PORT", "8765"))

LIVEF1_TOPICS = [
    "Position.z",
    "TimingData.z",
    "CarData.z",
    "SessionInfo",
    "WeatherData.z",
    "TimingAppData.z",
]

RECONNECT_DELAY = 5.0
BUFFER_FLUSH_INTERVAL = 0.05
