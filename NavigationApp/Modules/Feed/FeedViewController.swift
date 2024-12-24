//
//  FeedViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    lazy var openPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(openPostTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemCyan
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
        verticalStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        openPostButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    
        testButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
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
