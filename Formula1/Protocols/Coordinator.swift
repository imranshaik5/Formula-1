import SwiftUI

@MainActor
protocol Coordinator: AnyObject {
    associatedtype Route: Hashable
    var navigationPath: NavigationPath { get set }
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

extension Coordinator {
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
