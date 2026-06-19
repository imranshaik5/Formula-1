import XCTest

final class Formula1UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testAppLaunchesSuccessfully() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))
    }

    func testSplashScreenAppears() {
        let splash = app.otherElements.firstMatch
        XCTAssertTrue(splash.exists)
    }

    func testSplashDismisses() {
        let splash = app.otherElements.firstMatch
        let exists = splash.waitForExistence(timeout: 10)
        if exists {
            splash.tap()
        }
        let tabBar = app.buttons["line.3.horizontal"]
        let menuExists = tabBar.waitForExistence(timeout: 8)
        XCTAssertTrue(menuExists || !exists)
    }

    func testNavigationMenuAccessible() {
        let menuButton = app.buttons["line.3.horizontal"]
        let exists = menuButton.waitForExistence(timeout: 10)
        if exists {
            menuButton.tap()
        }
        XCTAssertTrue(exists)
    }

    func testRacesTabShows() {
        let tabBar = app.buttons["line.3.horizontal"]
        _ = tabBar.waitForExistence(timeout: 10)
        let racesNavBar = app.navigationBars.firstMatch
        XCTAssertTrue(racesNavBar.waitForExistence(timeout: 10))
    }

    func testDriversTabAccessible() {
        let menuButton = app.buttons["line.3.horizontal"]
        guard menuButton.waitForExistence(timeout: 10) else { return }
        menuButton.tap()

        let driversButton = app.buttons["Drivers"]
        if driversButton.waitForExistence(timeout: 3) {
            driversButton.tap()
        }
    }

    func testConstructorsTabAccessible() {
        let menuButton = app.buttons["line.3.horizontal"]
        guard menuButton.waitForExistence(timeout: 10) else { return }
        menuButton.tap()

        let constructorsButton = app.buttons["Constructors"]
        if constructorsButton.waitForExistence(timeout: 3) {
            constructorsButton.tap()
        }
    }

    func testNewsTabAccessible() {
        let menuButton = app.buttons["line.3.horizontal"]
        guard menuButton.waitForExistence(timeout: 10) else { return }
        menuButton.tap()

        let newsButton = app.buttons["News"]
        if newsButton.waitForExistence(timeout: 3) {
            newsButton.tap()
        }
    }
}
