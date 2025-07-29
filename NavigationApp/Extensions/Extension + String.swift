import Foundation

extension String {
    var digits: String { "0123456789" }
    var lowercase: String { "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { lowercase + uppercase }
    var printable: String { digits + letters }

    mutating func replace(at index: Int, with character: Character) {
        var array = Array(self)
        array[index] = character
        self = String(array)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    array.firstIndex(of: String(character)) ?? 0
}

func characterAt(index: Int, _ array: [String]) -> Character {
    index < array.count ? Character(array[index]) : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str = string

    if str.count == 0 {
        str.append(characterAt(index: 0, array))
    } else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = generateBruteForce(String(str.dropLast()), fromArray: array) + String(str.last!)
        }
    }

    return str
}
