import UIKit
import SnapKit

protocol LoginViewModelDelegate: AnyObject {
    func didReceiveErrorMessage(_ message: String?)
    func updateLockoutUI(remainingSeconds: Int)
    func lockoutDidEnd()
}

class LogInViewController: UIViewController {
    private var viewModel: LoginViewModeling

    // MARK: - UI элементы
    private lazy var scrollView = UIScrollView()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var lockoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.styleAsInput(topCorners: true)
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.styleAsInput(topCorners: false)
        return textField
    }()

    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(bruteForceTapped), for: .touchUpInside)
        return button
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Инициализация
    init(viewModel: LoginViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) не реализован") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.checkLockoutStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - UI Setup

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(views: [
            logoImageView,
            lockoutLabel,
            loginTextField,
            passwordTextField,
            logInButton,
            bruteForceButton,
            errorLabel,
            activityIndicator
        ])
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentView.snp.makeConstraints { $0.edges.equalTo(view) }

        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
            $0.height.width.equalTo(100)
        }

        lockoutLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(loginTextField.snp.top).offset(-8)
            $0.height.equalTo(20)
        }

        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lockoutLabel.snp.top).offset(-4)
        }

        loginTextField.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(120)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(loginTextField.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        logInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        bruteForceButton.snp.makeConstraints {
            $0.top.equalTo(logInButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        activityIndicator.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField)
            $0.trailing.equalTo(passwordTextField.snp.trailing).inset(8)
        }
    }

    // MARK: - Actions

    @objc private func logInButtonTapped() {
        do {
            let login = try validateLogin()
            let password = try validatePassword()
            viewModel.login(login, password)
        } catch {
            showAlert(with: error.localizedDescription)
        }
    }

    @objc private func bruteForceTapped() {
        let randomPassword = generateRandomPassword(length: 3)
        activityIndicator.startAnimating()
        passwordTextField.text = ""

        let bruteForcer = PasswordBruteForcer()
        bruteForcer.bruteForce(passwordToUnlock: randomPassword) { [weak self] foundPassword in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.passwordTextField.isSecureTextEntry = false
                self.passwordTextField.text = foundPassword
            }
        }
    }

    // MARK: - Helpers

    private func validateLogin() throws -> String {
        guard let login = loginTextField.text, !login.isEmpty else {
            throw LoginError.emptyLogin
        }
        return login
    }

    private func validatePassword() throws -> String {
        guard let password = passwordTextField.text, !password.isEmpty else {
            throw LoginError.emptyPassword
        }
        return password
    }

    private func generateRandomPassword(length: Int) -> String {
        let characters = String().printable
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }

    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - LoginViewModelDelegate

extension LogInViewController: LoginViewModelDelegate {
    func didReceiveErrorMessage(_ message: String?) {
        errorLabel.text = message
    }

    func updateLockoutUI(remainingSeconds: Int) {
        lockoutLabel.text = "Попытки закончились, ждите \(remainingSeconds) сек."
        lockoutLabel.isHidden = false
        logInButton.setTitle("Вход заблокирован", for: .normal)
        logInButton.isEnabled = false
    }

    func lockoutDidEnd() {
        logInButton.setTitle("Log In", for: .normal)
        logInButton.isEnabled = true
        lockoutLabel.isHidden = true
    }
}

// MARK: - Custom TextField Styling

private extension UITextField {
    func styleAsInput(topCorners: Bool) {
        borderStyle = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.maskedCorners = topCorners ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        rightViewMode = .always
    }
}

