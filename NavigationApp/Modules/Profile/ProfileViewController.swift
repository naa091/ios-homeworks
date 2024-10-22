//
//  ProfileViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var setTitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change title", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
}

private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .green
        view.addSubview(profileHeaderView)
        view.addSubview(setTitleButton)
    }
   
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            setTitleButton.heightAnchor.constraint(equalToConstant: 50),
            setTitleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            setTitleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setNavigation() {
        navigationItem.title = "Profile"
    }
}
