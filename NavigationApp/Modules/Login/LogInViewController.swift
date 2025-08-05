import UIKit
import SnapKit

final class LogInViewController: UIViewController {
    private let viewModel: LoginViewModeling

    // MARK: - UI
    private lazy var emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        tf.leftViewMode = .always
        return tf
    }()

    private lazy var passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        tf.leftViewMode = .always
        return tf
    }()

    private lazy var loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Login", for: .normal)
        b.layer.cornerRadius = 8
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.isEnabled = false
        b.alpha = 0.5
        b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return b
    }()

    private lazy var registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Register", for: .normal)
        b.layer.cornerRadius = 8
        b.backgroundColor = .systemGreen
        b.setTitleColor(.white, for: .normal)
        b.isEnabled = false
        b.alpha = 0.5
        b.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return b
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13)
        return l
    }()

    private lazy var lockoutLabel: UILabel = {
        let l = UILabel()
        l.textColor = .systemRed
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    private lazy var activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .medium)
        a.hidesWhenStopped = true
        return a
    }()

    // MARK: - Init
    init(viewModel: LoginViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        if let vm = viewModel as? LoginViewModel {
            vm.delegate = self
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setupConstraints()
        emailField.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        viewModel.checkLockoutStatus()
    }

    @objc private func fieldsChanged() {
        let email = emailField.text ?? ""
        let pass = passwordField.text ?? ""
        let enabled = !email.trimmingCharacters(in: .whitespaces).isEmpty && !pass.isEmpty
        [loginButton, registerButton].forEach {
            $0.isEnabled = enabled
            $0.alpha = enabled ? 1 : 0.5
        }
    }

    @objc private func loginTapped() {
        clearUI()
        activity.startAnimating()
        viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func registerTapped() {
        clearUI()
        activity.startAnimating()
        viewModel.register(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    private func clearUI() {
        errorLabel.text = nil
        lockoutLabel.isHidden = true
    }

    private func showError(_ text: String) {
        errorLabel.text = text
    }

    private func updateLockoutUI(remaining: Int) {
        lockoutLabel.text = "Попытки закончились, ждите \(remaining) сек."
        lockoutLabel.isHidden = false
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }

    private func resetLockoutUI() {
        loginButton.setTitle("Login", for: .normal)
        registerButton.setTitle("Register", for: .normal)
        loginButton.isEnabled = true
        registerButton.isEnabled = true
        lockoutLabel.isHidden = true
    }

    private func setup() {
        [emailField, passwordField, loginButton, registerButton, errorLabel, lockoutLabel, activity].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        emailField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(emailField)
            make.height.equalTo(44)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.equalTo(emailField)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.trailing.equalTo(emailField)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        lockoutLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.leading.trailing.equalTo(emailField)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(lockoutLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(emailField)
        }
        activity.snp.makeConstraints { make in
            make.centerY.equalTo(loginButton)
            make.trailing.equalTo(loginButton).inset(12)
        }
    }
}

extension LogInViewController: LoginViewModelDelegate {
    func didReceiveError(_ message: String) {
        activity.stopAnimating()
        showError(message)
    }

    func didUpdateLockout(remainingSeconds: Int) {
        activity.stopAnimating()
        updateLockoutUI(remaining: remainingSeconds)
    }

    func lockoutEnded() {
        activity.stopAnimating()
        resetLockoutUI()
    }

    func didLoginSuccessfully() {
        activity.stopAnimating()
        resetLockoutUI()
        NotificationCenter.default.post(name: .didLogin, object: nil)
    }

    func didRegisterSuccessfully() {
        activity.stopAnimating()
        resetLockoutUI()
        NotificationCenter.default.post(name: .didLogin, object: nil)
    }
}

