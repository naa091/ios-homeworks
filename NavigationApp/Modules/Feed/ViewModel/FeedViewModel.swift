import Foundation
import UIKit

final class FeedViewModel {
    private let model = FeedModel()
    
    var onResultChanged: ((String, UIColor) -> Void)?
    
    func checkGuess(word: String?) {
        let input = word?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !input.isEmpty else {
            onResultChanged?("Input cannot be empty!", .red)
            return
        }

        let isCorrect = model.check(word: input)
        onResultChanged?(isCorrect ? "Correct!" : "Incorrect!", isCorrect ? .systemGreen : .systemRed)
    }
}
