import Foundation

final class PasswordBruteForcer {
    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void) {
        let allowedChars: [String] = String().printable.map { String($0) }
        var password = ""
        
        DispatchQueue.global(qos: .userInitiated).async {
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: allowedChars)
            }
            DispatchQueue.main.async {
                completion(password)
            }
        }
    }
}
