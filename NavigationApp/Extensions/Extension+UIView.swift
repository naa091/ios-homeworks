//
//  Extension+UIView.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import UIKit

extension UIView {
    func addSubviews(views: [UIView]) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
