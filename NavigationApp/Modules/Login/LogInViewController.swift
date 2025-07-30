import UIKit
import SnapKit

protocol LoginViewModelDelegate: AnyObject {
    func didReciveErorMessage(_ message: String?)
}

private enum LoginLockoutKeys {
    static let failedAttempts = "loginFailedAttempts"
    static let lockoutUntil = "loginLockoutUntil"
}

class LogInViewController: UIViewController {
    private var viewModel: LoginViewModeling
    private var lockoutTimer: Timer?
    private var remainingLockoutSeconds: Int = 0
    
    // MARK: - UI элементы (без IBOutlet)
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        print("🌀 scrollView создан")
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        print("📄 contentView создан")
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        print("🖼 logoImageView создан")
        return imageView
    }()
    
    // Добавляем красный label для отображения блокировки
    lazy var lockoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.rightViewMode = .always
        print("⌨️ loginTextField создан")
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.rightViewMode = .always
        print("🔒 passwordTextField создан")
        return textField
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        print("🔘 logInButton создан")
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        print("⏳ activityIndicator создан")
        return indicator
    }()
    
    lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(bruteForceTapped), for: .touchUpInside)
        print("🔐 bruteForceButton создан")
        return button
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12, weight: .bold)
        print("❗️ errorLabel создан")
        return label
    }()
    
    // MARK: - Инициализация
    init(viewModel: LoginViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("🚀 LogInViewController init")
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) не реализован") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ viewDidLoad вызван")
        viewModel.delegate = self
        checkLockoutStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        print("👀 viewWillAppear вызван, navigationBar скрыт")
    }
}

//MARK: -  Private EXT
private extension LogInViewController {

    // MARK: - Настройка UI

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
            errorLabel,
            bruteForceButton,
            activityIndicator
        ])
        print("🛠 setupView выполнен, все вью добавлены")
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
            make.height.width.equalTo(100)
        }

        lockoutLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(loginTextField.snp.top).offset(-8)
            make.height.equalTo(20)
        }

        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lockoutLabel.snp.top).offset(-4)
        }

        loginTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(logoImageView.snp.bottom).offset(120)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(loginTextField.snp.bottom).offset(1)
        }
        logInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        bruteForceButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField.snp.trailing).inset(8)
        }
        print("📐 setupConstraints выполнен")
    }

    // MARK: - Логика блокировки

    func checkLockoutStatus() {
        print("🕵️ Проверяем статус блокировки")

        if let lockoutUntil = UserDefaults.standard.object(forKey: LoginLockoutKeys.lockoutUntil) as? Date {
            let remaining = Int(lockoutUntil.timeIntervalSinceNow)
            if remaining > 0 {
                print("⏰ Осталось блокировки: \(remaining) секунд")
                startLockoutTimer(seconds: remaining)
            } else {
                clearLockout()
            }
        } else {
            print("✅ Нет активной блокировки")
            clearLockout()
        }
    }

    func startLockoutTimer(seconds: Int = 30) {
        print("🔐 Стартуем блокировку на \(seconds) секунд")

        remainingLockoutSeconds = seconds
        updateLockoutUI()
        logInButton.isEnabled = false
        lockoutLabel.isHidden = false

        lockoutTimer?.invalidate()
        lockoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingLockoutSeconds -= 1
            if self.remainingLockoutSeconds > 0 {
                self.updateLockoutUI()
            } else {
                timer.invalidate()
                self.clearLockout()
            }
        }
    }

    func updateLockoutUI() {
        lockoutLabel.text = "Попытки закончились, ждите \(remainingLockoutSeconds) сек."
        logInButton.setTitle("Вход заблокирован", for: .normal)
    }

    func clearLockout() {
        print("♻️ Сбрасываем блокировку и счётчик")
        UserDefaults.standard.set(0, forKey: LoginLockoutKeys.failedAttempts)
        UserDefaults.standard.removeObject(forKey: LoginLockoutKeys.lockoutUntil)
        logInButton.isEnabled = true
        logInButton.setTitle("Log In", for: .normal)
        lockoutLabel.isHidden = true
    }

    // MARK: - Действия кнопок

    @objc func logInButtonTapped() {
        print("🔘 Кнопка LogIn нажата")

        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("⚠️ Логин или пароль пусты")
            errorLabel.text = "Введите логин"
            return
        }

        print("📥 Логин: \(login), Пароль: \(password)")
        viewModel.login(login, password)
    }

    @objc func bruteForceTapped() {
        print("🔐 Нажата кнопка bruteForce")

        let randomPassword = generateRandomPassword(length: 3)
        print("🔑 Сгенерирован пароль: \(randomPassword)")

        activityIndicator.startAnimating()
        passwordTextField.text = ""
        passwordTextField.isSecureTextEntry = true

        let bruteForcer = PasswordBruteForcer()
        bruteForcer.bruteForce(passwordToUnlock: randomPassword) { [weak self] foundPassword in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.passwordTextField.isSecureTextEntry = false
            self.passwordTextField.text = foundPassword
            print("✅ Пароль найден: \(foundPassword)")
        }
    }

    func generateRandomPassword(length: Int) -> String {
        let characters = String().printable
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}

// MARK: - LoginViewModelDelegate

extension LogInViewController: LoginViewModelDelegate {
    func didReciveErorMessage(_ message: String?) {
        print("❌ didReciveErorMessage вызвано с сообщением: \(message ?? "nil")")

        DispatchQueue.main.async {
            self.errorLabel.text = message

            var attempts = UserDefaults.standard.integer(forKey: LoginLockoutKeys.failedAttempts)
            attempts += 1
            UserDefaults.standard.set(attempts, forKey: LoginLockoutKeys.failedAttempts)

            if attempts >= 3 {
                print("🚫 Превышено число попыток. Стартуем таймер блокировки.")
                self.startLockoutTimer()
            }
        }
    }
}

