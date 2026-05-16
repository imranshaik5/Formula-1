import Foundation

enum LoadState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var value: T? {
        if case .loaded(let v) = self { return v }
        return nil
    }

    var error: Error? {
        if case .error(let e) = self { return e }
        return nil
    }
}

extension LoadState: Equatable where T: Equatable {
    static func == (lhs: LoadState<T>, rhs: LoadState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading): return true
        case (.loaded(let a), .loaded(let b)): return a == b
        case (.error, .error): return true
        default: return false
        }
    }
}
