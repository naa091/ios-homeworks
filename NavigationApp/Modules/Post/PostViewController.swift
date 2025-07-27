//
//  PostViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.10.2024.
//

import UIKit

class PostViewController: UIViewController {
    let customBackgroundColor: UIColor
    
    init(customBackgroundColor: UIColor) {
        self.customBackgroundColor = customBackgroundColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customBackgroundColor
    }
    
}
