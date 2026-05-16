import Testing
import Foundation

@testable import Formula1

struct LoadStateTests {

    @Test func idleState() {
        let state: LoadState<Int> = .idle
        #expect(!state.isLoading)
        #expect(state.value == nil)
        #expect(state.error == nil)
    }

    @Test func loadingState() {
        let state: LoadState<Int> = .loading
        #expect(state.isLoading)
        #expect(state.value == nil)
        #expect(state.error == nil)
    }

    @Test func loadedState() {
        let state: LoadState<String> = .loaded("hello")
        #expect(!state.isLoading)
        #expect(state.value == "hello")
        #expect(state.error == nil)
    }

    @Test func errorState() {
        let error = NSError(domain: "test", code: 1)
        let state: LoadState<Int> = .error(error)
        #expect(!state.isLoading)
        #expect(state.value == nil)
        #expect(state.error as? NSError == error)
    }

    @Test func equatableIdle() {
        let a: LoadState<Int> = .idle
        let b: LoadState<Int> = .idle
        #expect(a == b)
    }

    @Test func equatableLoading() {
        let a: LoadState<String> = .loading
        let b: LoadState<String> = .loading
        #expect(a == b)
    }

    @Test func equatableLoaded() {
        let a: LoadState<[Int]> = .loaded([1, 2, 3])
        let b: LoadState<[Int]> = .loaded([1, 2, 3])
        #expect(a == b)
    }

    @Test func equatableLoadedNotEqual() {
        let a: LoadState<Int> = .loaded(5)
        let b: LoadState<Int> = .loaded(10)
        #expect(a != b)
    }

    @Test func equatableErrors() {
        let a: LoadState<Int> = .error(NSError(domain: "a", code: 1))
        let b: LoadState<Int> = .error(NSError(domain: "b", code: 2))
        #expect(a == b)
    }

    @Test func equatableDifferentCases() {
        let idle: LoadState<Int> = .idle
        let loading: LoadState<Int> = .loading
        #expect(idle != loading)
    }

    @Test func valueForNonLoadedReturnsNil() {
        let idle: LoadState<Int> = .idle
        #expect(idle.value == nil)
    }
}
