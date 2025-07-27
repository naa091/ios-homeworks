import Foundation

final class FeedModel {
    private let secretWord = "password"

    func check(word: String) -> Bool {
        return word.lowercased() == secretWord.lowercased()
    }
}
