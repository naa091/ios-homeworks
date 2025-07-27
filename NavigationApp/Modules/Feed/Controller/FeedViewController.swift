//
//  FeedViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    private let viewModel = FeedViewModel()
    private let feedView = FeedView()
    
    override func loadView() {
        feedView.onOpenPostTapped = { [weak self] in self?.openPostTapped() }
        feedView.onTestTapped = { [weak self] in self?.testTapped() }
        feedView.onCheckTapped = { [weak self] in self?.checkGuess() }
        self.view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

//MARK: - Private Extension
private extension FeedViewController {
    func bindViewModel() {
        viewModel.onResultChanged = { [weak self] text, color in
            DispatchQueue.main.async {
                self?.feedView.resultLabel.text = text
                self?.feedView.resultLabel.textColor = color
            }
        }
    }

    func checkGuess() {
        viewModel.checkGuess(word: feedView.textField.text)
    }

    func openPostTapped() {
        let postVC = PostViewController(customBackgroundColor: .systemOrange)
        navigationController?.pushViewController(postVC, animated: true)
    }

    func testTapped() {
        let postVC = PostViewController(customBackgroundColor: .systemMint)
        navigationController?.pushViewController(postVC, animated: true)
    }
}
