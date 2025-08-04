import UIKit

final class InfoViewController: UIViewController {
    private let titleLabel = UILabel()
    private let planetPeriodLabel = UILabel()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        loadData()
    }
}

private extension InfoViewController {
    func setupUI() {
        [titleLabel, planetPeriodLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 16)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(planetPeriodLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func loadData() {
        NetworkService.shared.fetchTodoTitle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    self?.titleLabel.text = "Title:\n\(title)"
                case .failure(let error):
                    print("❌ Todo error: \(error.localizedDescription)")
                }
            }
        }

        NetworkService.shared.fetchPlanet { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let planet):
                    self?.planetPeriodLabel.text = "\(planet.name)'s orbital period: \(planet.orbitalPeriod) days"
                case .failure(let error):
                    print("❌ Planet error: \(error.localizedDescription)")
                }
            }
        }
    }
}

