import Foundation

protocol LiveTimingServiceProtocol: AnyObject {
    var onSnapshot: ((LiveRaceSnapshot) -> Void)? { get set }
    var isConnected: Bool { get }

    func connect()
    func disconnect()
}
