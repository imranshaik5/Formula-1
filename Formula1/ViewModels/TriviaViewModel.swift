import Foundation

@MainActor
final class TriviaViewModel: ObservableObject {
    @Published private(set) var questions: [TriviaQuestion] = []
    @Published private(set) var currentIndex = 0
    @Published private(set) var score = 0
    @Published private(set) var answered = false
    @Published private(set) var selectedIndex: Int?
    @Published private(set) var isFinished = false

    private let totalQuestions = 10

    var currentQuestion: TriviaQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progress: Double {
        Double(currentIndex) / Double(totalQuestions)
    }

    func startGame() {
        questions = Array(TriviaQuestion.all.shuffled().prefix(totalQuestions))
        currentIndex = 0
        score = 0
        answered = false
        selectedIndex = nil
        isFinished = false
    }

    func selectAnswer(_ index: Int) {
        guard !answered, let question = currentQuestion else { return }
        answered = true
        selectedIndex = index
        if index == question.correctIndex {
            score += 1
        }
    }

    func nextQuestion() {
        answered = false
        selectedIndex = nil
        if currentIndex + 1 >= questions.count {
            isFinished = true
        } else {
            currentIndex += 1
        }
    }

    func reset() {
        startGame()
    }
}
