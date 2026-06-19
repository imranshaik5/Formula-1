import XCTest
import Foundation
@testable import Formula1

@MainActor
final class F1DBPredictorTests: XCTestCase {
    var f1db: F1DBService!
    var predictor: F1DBPredictor!

    override func setUp() async throws {
        f1db = F1DBService.shared
        f1db.ensureLoaded()
        try await Task.sleep(for: .seconds(1))
        predictor = F1DBPredictor(f1db: f1db)
    }

    func testPredictTop5ReturnsFiveResults() {
        let predictions = predictor.predictTop5(for: nil)
        XCTAssertEqual(predictions.count, 5)
    }

    func testPredictionsHaveValidPositions() {
        let predictions = predictor.predictTop5(for: nil)
        for (index, pred) in predictions.enumerated() {
            XCTAssertEqual(pred.predictedPosition, index + 1)
        }
    }

    func testPredictionsHaveNonEmptyNames() {
        let predictions = predictor.predictTop5(for: nil)
        for pred in predictions {
            XCTAssertFalse(pred.driverName.isEmpty)
            XCTAssertFalse(pred.driverAbbreviation.isEmpty)
            XCTAssertFalse(pred.teamName.isEmpty)
        }
    }

    func testPredictionsSortedByScore() {
        let predictions = predictor.predictTop5(for: nil)
        for i in 0..<(predictions.count - 1) {
            XCTAssertGreaterThanOrEqual(predictions[i].score, predictions[i + 1].score)
        }
    }

    func testPredictionsHaveFactors() {
        let predictions = predictor.predictTop5(for: nil)
        for pred in predictions {
            XCTAssertEqual(pred.factors.count, 5)
        }
    }

    func testPredictionsHaveFactorLabels() {
        let predictions = predictor.predictTop5(for: nil)
        let expectedLabels = ["Career", "Season", "Circuit", "Momentum", "Qualifying"]
        for pred in predictions {
            for (index, factor) in pred.factors.enumerated() {
                XCTAssertEqual(factor.label, expectedLabels[index])
                XCTAssertFalse(factor.value.isEmpty)
                XCTAssertGreaterThan(factor.weight, 0)
            }
        }
    }

    func testPredictionsHaveValidIDs() {
        let predictions = predictor.predictTop5(for: nil)
        for pred in predictions {
            XCTAssertFalse(pred.id.isEmpty)
            XCTAssertFalse(pred.driverId.isEmpty)
        }
    }

    func testWinProbabilitiesSumToOne() {
        let predictions = predictor.predictTop5(for: nil)
        let totalProb = predictions.reduce(0.0) { $0 + $1.winProbability }
        XCTAssertEqual(totalProb, 1.0, accuracy: 0.01)
    }
}
