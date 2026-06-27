import Foundation
import os

final class LiveTimingService: LiveTimingServiceProtocol, @unchecked Sendable {
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let decoder = JSONDecoder()
    private var _isActive = false
    private let lock = OSAllocatedUnfairLock()

    private let host: String
    private let port: Int

    var onSnapshot: ((LiveRaceSnapshot) -> Void)?
    var isConnected: Bool {
        webSocketTask?.state == .running
    }

    init(host: String = "127.0.0.1", port: Int = 8765) {
        self.host = host
        self.port = port
        self.session = URLSession(configuration: .ephemeral)
    }

    func connect() {
        lock.lock()
        if _isActive { lock.unlock(); return }
        _isActive = true
        lock.unlock()
        _connect()
    }

    func disconnect() {
        lock.lock()
        _isActive = false
        lock.unlock()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }

    private func _connect() {
        lock.lock()
        let active = _isActive
        lock.unlock()
        guard active else { return }
        guard let url = URL(string: "ws://\(host):\(port)/ws") else { return }
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleMessage(text)
                    }
                @unknown default:
                    break
                }
                self.receiveMessage()
            case .failure:
                self.reconnect()
            }
        }
    }

    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            let snapshot = try decoder.decode(LiveRaceSnapshot.self, from: data)
            onSnapshot?(snapshot)
        } catch {
            if !text.contains("\"type\":\"pong\"") {
                print("[LiveTiming] Decode error: \(error)")
            }
        }
    }

    private func reconnect() {
        webSocketTask = nil
        lock.lock()
        let active = _isActive
        lock.unlock()
        guard active else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?._connect()
        }
    }
}
