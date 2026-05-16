import Foundation
import NaturalLanguage

enum Summarizer {
    static func extractSummary(from text: String, sentenceCount: Int = 2) -> String {
        let tagger = NLTagger(tagSchemes: [.tokenType])
        tagger.string = text

        var sentences: [String] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .sentence, scheme: .tokenType) { _, range in
            sentences.append(String(text[range]))
            return true
        }

        guard sentences.count > sentenceCount else {
            return sentences.prefix(sentenceCount).joined().trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let words = text.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 3 }
        let wordFreq = Dictionary(words.map { ($0, 1) }, uniquingKeysWith: +)
        let maxFreq = Double(wordFreq.values.max() ?? 1)

        let scored = sentences.map { sentence -> (String, Double) in
            let sentenceWords = sentence.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 3 }
            guard !sentenceWords.isEmpty else { return (sentence, 0) }
            let score = sentenceWords.reduce(0.0) { $0 + (wordFreq[$1].map { Double($0) / maxFreq } ?? 0) }
            return (sentence, score / Double(sentenceWords.count))
        }

        let topSentences = scored
            .sorted { $0.1 > $1.1 }
            .prefix(sentenceCount)
            .sorted { sentences.firstIndex(of: $0.0) ?? 0 < sentences.firstIndex(of: $1.0) ?? 0 }
            .map { $0.0 }

        return topSentences.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
