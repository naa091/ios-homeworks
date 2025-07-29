//
//  LogInViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 22.10.2024.
//

import UIKit
import SnapKit

protocol LoginViewModelDelegate: AnyObject {
    func didReciveErorMessage(_ message: String?)
}

class LogInViewController: UIViewController {
    private var viewModel: LoginViewModeling
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        
        return textField
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(bruteForceTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }()
    
    init(viewModel: LoginViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        print("✅ Делегат установлен в ViewController: \(viewModel.delegate != nil)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

private extension LogInViewController {
    func setupView() {
        view.addSubviews(views: [scrollView])
        scrollView.addSubviews(views: [contentView])
        contentView.addSubviews(views: [logoImageView, loginTextField, passwordTextField, logInButton, errorLabel, bruteForceButton, activityIndicator])
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
            make.height.width.equalTo(100)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginTextField.snp.top).offset(-16)
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
    }
    
    @objc func logInButtonTapped() {
        guard let loginText = loginTextField.text,
              !loginText.isEmpty,
              let passwordText = passwordTextField.text,
              !passwordText.isEmpty else {
            errorLabel.text = "Введите логин"
            return
        }
        print("logInButtonTapped")
        viewModel.login(loginText, passwordText)
    }
    
    @objc func bruteForceTapped() {
        let randomPassword = generateRandomPassword(length: 3)
        print("🔐 Сгенерирован пароль: \(randomPassword)")

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

extension LogInViewController: LoginViewModelDelegate {
    func didReciveErorMessage(_ message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            print("🔥 Ошибка получена в VC: \(message ?? "nil")") // Проверяем, передаётся ли сообщение
        }
    }
}
