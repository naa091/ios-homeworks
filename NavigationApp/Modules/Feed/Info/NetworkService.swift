import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func fetchTodoTitle(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let title = json["title"] as? String {
                    completion(.success(title))
                } else {
                    completion(.failure(NSError(domain: "ParsingError", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPlanet(completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let url = URL(string: "https://swapi.py4e.com/api/planets/1/") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                completion(.success(planet))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
