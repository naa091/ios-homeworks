//
//  ProfileViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    override func loadView() {
        view = ProfileHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
}

private extension ProfileViewController {
    func setNavigation() {
        navigationItem.title = "Profile"
    }
}
