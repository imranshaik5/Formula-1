import SwiftUI

struct TriviaView: View {
    @StateObject private var viewModel = TriviaViewModel()

    var body: some View {
        Group {
            if viewModel.questions.isEmpty {
                startView
            } else if viewModel.isFinished {
                resultsView
            } else {
                questionView
            }
        }
        .background(F1Theme.background.ignoresSafeArea())
        .navigationTitle(Strings.Trivia.title)
        .navigationBarTitleDisplayMode(.large)
    }

    private var startView: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.f1Accent)

            Text(Strings.Trivia.startTitle)
                .font(F1Theme.title)
                .foregroundColor(.white)

            Text(Strings.Trivia.startDescription)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(Strings.Trivia.startButton) {
                viewModel.startGame()
            }
            .buttonStyle(.borderedProminent)
            .tint(.f1Accent)
            .fontWeight(.bold)
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var questionView: some View {
        VStack(spacing: 0) {
            progressBar
            Spacer().frame(height: 20)
            scoreDisplay
            Spacer().frame(height: 16)
            questionCard
            Spacer()
            nextButton
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
    }

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text(Strings.Trivia.questionLabel(viewModel.currentIndex + 1, viewModel.questions.count))
                    .font(F1Theme.caption)
                    .foregroundColor(.f1TextSecondary)
                Spacer()
            }
            ProgressView(value: viewModel.progress)
                .tint(.f1Accent)
        }
        .padding(.top, 8)
    }

    private var scoreDisplay: some View {
        HStack {
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.f1Accent)
                Text("\(viewModel.score)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }

    private var questionCard: some View {
        VStack(spacing: 20) {
            Text(viewModel.currentQuestion?.question ?? "")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            VStack(spacing: 10) {
                ForEach(Array(viewModel.currentQuestion?.options.enumerated() ?? [].enumerated()), id: \.offset) { index, option in
                    optionButton(option, index: index)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func optionButton(_ text: String, index: Int) -> some View {
        Button {
            viewModel.selectAnswer(index)
        } label: {
            HStack {
                Text(text)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(foregroundColor(for: index))
                    .multilineTextAlignment(.leading)
                Spacer()
                if viewModel.answered {
                    Image(systemName: iconName(for: index))
                        .foregroundColor(foregroundColor(for: index))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(backgroundColor(for: index))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor(for: index), lineWidth: viewModel.answered ? 1.5 : 1)
            )
        }
        .disabled(viewModel.answered)
    }

    private func backgroundColor(for index: Int) -> Color {
        guard viewModel.answered, let question = viewModel.currentQuestion else {
            return Color.white.opacity(0.06)
        }
        if index == question.correctIndex {
            return Color.f1NeonGreen.opacity(0.15)
        }
        if index == viewModel.selectedIndex {
            return Color.f1Accent.opacity(0.15)
        }
        return Color.white.opacity(0.06)
    }

    private func borderColor(for index: Int) -> Color {
        guard viewModel.answered, let question = viewModel.currentQuestion else {
            return Color.white.opacity(0.06)
        }
        if index == question.correctIndex {
            return Color.f1NeonGreen
        }
        if index == viewModel.selectedIndex {
            return Color.f1Accent
        }
        return Color.white.opacity(0.06)
    }

    private func foregroundColor(for index: Int) -> Color {
        guard viewModel.answered, let question = viewModel.currentQuestion else {
            return .white
        }
        if index == question.correctIndex {
            return .f1NeonGreen
        }
        if index == viewModel.selectedIndex {
            return .f1Accent
        }
        return .white.opacity(0.7)
    }

    private func iconName(for index: Int) -> String {
        guard let question = viewModel.currentQuestion else { return "" }
        if index == question.correctIndex {
            return "checkmark.circle.fill"
        }
        if index == viewModel.selectedIndex {
            return "xmark.circle.fill"
        }
        return ""
    }

    @ViewBuilder
    private var nextButton: some View {
        if viewModel.answered {
            Button {
                viewModel.nextQuestion()
            } label: {
                Text(viewModel.currentIndex + 1 >= viewModel.questions.count ? Strings.Trivia.seeResults : Strings.Trivia.nextQuestion)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private var resultsView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundColor(.f1Accent)

            Text(Strings.Trivia.resultTitle)
                .font(F1Theme.title)
                .foregroundColor(.white)

            Text("\(viewModel.score) / \(viewModel.questions.count)")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundColor(.f1Accent)

            Text(scoreMessage)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button(Strings.Trivia.playAgain) {
                viewModel.reset()
            }
            .buttonStyle(.borderedProminent)
            .tint(.f1Accent)
            .fontWeight(.bold)

            Button(Strings.Trivia.goHome) {
                viewModel.reset()
            }
            .font(F1Theme.caption)
            .foregroundColor(.f1TextSecondary)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var scoreMessage: String {
        let pct = Double(viewModel.score) / Double(max(viewModel.questions.count, 1))
        if pct >= 0.9 { return Strings.Trivia.messagePerfect }
        if pct >= 0.7 { return Strings.Trivia.messageGreat }
        if pct >= 0.5 { return Strings.Trivia.messageGood }
        return Strings.Trivia.messageTryAgain
    }
}
