//
//  FeedViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
//
class FeedViewController: UIViewController {
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var openPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openPostTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemCyan
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(testTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

private extension FeedViewController {
    func setupView() {
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(openPostButton)
        verticalStackView.addArrangedSubview(testButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            openPostButton.heightAnchor.constraint(equalToConstant: 50),
            openPostButton.widthAnchor.constraint(equalToConstant: 100),
            
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc func openPostTapped() {
        let postViewController = PostViewController(customBackgroundColor: .systemOrange)
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    @objc func testTapped() {
        let postViewController = PostViewController(customBackgroundColor: .systemMint)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
