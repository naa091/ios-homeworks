import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        let urlString: String
        switch configuration {
        case .dogImage(let url), .ageGuess(let url), .genderGuess(let url):
            urlString = url
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("Error:", error.localizedDescription)

                if let urlError = error as? URLError {
                    print("URLError code:", urlError.code.rawValue)
                } else {
                    print("Error (non-URLError):", error)
                }

                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            print("✅ Status Code:", httpResponse.statusCode)
            print("✅ Headers:", httpResponse.allHeaderFields)

            if let data = data, let string = String(data: data, encoding: .utf8) {
                print("✅ Data:\n", string)
            } else {
                print("Unable to decode data")
            }
        }

        task.resume()
    }
}
