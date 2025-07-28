//
//  ProfileHeaderView.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    private var statusText: String = ""
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Шкет")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Шкет"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray        
        return label
    }()
    
    lazy var statusTextField: UITextField = {
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
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func userData(user: User) {
        avatarImageView.image = user.avatar
        fullNameLabel.text = user.name
    }
}

private extension ProfileHeaderView {
    func setupView() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubviews(views: [avatarImageView, setStatusButton, statusTextField, fullNameLabel, statusLabel])
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.leading.top.equalToSuperview().inset(16)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }
        
        setStatusButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
    }
    
    @objc func setStatusButtonTapped() {
        statusLabel.text = statusText
        print("\(statusLabel.text ?? "No status text")")
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        self.statusText = textField.text ?? ""
    }
}
