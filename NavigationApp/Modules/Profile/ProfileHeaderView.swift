//
//  ProfileHeaderView.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    private var statusText: String = ""
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Шкет")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Шкет"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var addStatusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add status"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(setStatusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
}

private extension ProfileHeaderView {
    func setupView() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubview(profileImage)
        addSubview(setStatusButton)
        addSubview(addStatusTextField)
        addSubview(nameLabel)
        addSubview(statusLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
         
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            setStatusButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            
            statusLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            statusLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            
            addStatusTextField.heightAnchor.constraint(equalToConstant: 40),
            addStatusTextField.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            addStatusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addStatusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -4),
            ])
    }
    
    @objc func setStatusButtonTapped() {
        statusLabel.text = statusText
        print("\(statusLabel.text ?? "No status text")")
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        self.statusText = textField.text ?? ""
    }
}
