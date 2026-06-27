import asyncio
import json
import threading
import time
from collections import defaultdict
from queue import Queue, Empty
from dataclasses import asdict
from typing import Any, Optional

from config import LIVEF1_TOPICS, RECONNECT_DELAY
from models import LiveDriverPosition, LiveDataSnapshot, LiveFastestLap, LiveSessionState


class LiveF1Client:
    def __init__(self):
        self._data_queue: Queue = Queue(maxsize=5000)
        self._running = threading.Event()
        self._client: Optional[Any] = None
        self._thread: Optional[threading.Thread] = None
        self._loop: Optional[asyncio.AbstractEventLoop] = None

    def start(self):
        if self._running.is_set():
            return
        self._running.set()
        self._thread = threading.Thread(target=self._run_client, daemon=True, name="livef1-client")
        self._thread.start()

    def stop(self):
        self._running.clear()
        if self._client:
            try:
                if self._loop and not self._loop.is_closed():
                    asyncio.run_coroutine_threadsafe(self._shutdown(), self._loop)
            except Exception:
                pass
        if self._thread and self._thread.is_alive():
            self._thread.join(timeout=5)

    def get_data_batch(self, timeout: float = 0.01) -> list[dict[str, Any]]:
        batch = []
        try:
            while True:
                record = self._data_queue.get_nowait()
                batch.append(record)
        except Empty:
            pass
        return batch

    async def _shutdown(self):
        self._running.clear()

    def _run_client(self):
        while self._running.is_set():
            try:
                self._loop = asyncio.new_event_loop()
                asyncio.set_event_loop(self._loop)
                self._loop.run_until_complete(self._connect_and_stream())
            except Exception as e:
                print(f"[LiveF1Client] Connection error: {e}")
                if self._running.is_set():
                    time.sleep(RECONNECT_DELAY)

    async def _connect_and_stream(self):
        import livef1
        from livef1.adapters import RealF1Client
        self._client = RealF1Client(topics=LIVEF1_TOPICS)

        @self._client.callback("live_timing_handler")
        async def handle_data(records: dict[str, list]):
            batch = {}
            for topic, items in records.items():
                for item in items:
                    batch["topic"] = topic
                    batch["data"] = item
                    batch["ts"] = time.time()
                    try:
                        self._data_queue.put_nowait(dict(batch))
                    except Exception:
                        pass

        print(f"[LiveF1Client] Connecting with topics: {LIVEF1_TOPICS}")
        self._client.run()

    @property
    def is_connected(self) -> bool:
        return self._running.is_set() and self._thread is not None and self._thread.is_alive()
