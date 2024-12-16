//
//  PostViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.10.2024.
//

import UIKit
import StorageService

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
#if DEBUG
        view.backgroundColor = .red
#else
        view.backgroundColor = .green
#endif
        let post = Post(title: "")
    }
}
