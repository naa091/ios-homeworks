//
//  ProfileTableHederView.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 03.11.2024.
//

import UIKit

class ProfileTableHederView: UIView {
    lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var setTitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change title", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupConstrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProfileTableHederView {
    func setupView() {
        backgroundColor = .green
        addSubview(profileHeaderView)
        addSubview(setTitleButton)
    }
    
    func setupConstrain() {
        NSLayoutConstraint.activate([
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            profileHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderView.topAnchor.constraint(equalTo: topAnchor),
            
            setTitleButton.heightAnchor.constraint(equalToConstant: 50),
            setTitleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            setTitleButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            setTitleButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
