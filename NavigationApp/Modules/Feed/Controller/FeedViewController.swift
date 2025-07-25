//
//  FeedViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    private let model = FeedModel()
    private let feedView = FeedView()

    override func loadView() {
        let rootView = FeedView()
        rootView.onOpenPostTapped = { [weak self] in self?.openPostTapped() }
        rootView.onTestTapped = { [weak self] in self?.testTapped() }
        rootView.onCheckTapped = { [weak self] in self?.checkGuess() }
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Actions
private extension FeedViewController {
    func openPostTapped() {
        let postVC = PostViewController(customBackgroundColor: .systemOrange)
        navigationController?.pushViewController(postVC, animated: true)
    }

    func testTapped() {
        let postVC = PostViewController(customBackgroundColor: .systemMint)
        navigationController?.pushViewController(postVC, animated: true)
    }

    func checkGuess() {
        let input = feedView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !input.isEmpty else {
            feedView.resultLabel.text = "Input cannot be empty!"
            feedView.resultLabel.textColor = .red
            
            return
        }

        let isCorrect = model.check(word: input)
        feedView.resultLabel.text = isCorrect ? "Correct!" : "Incorrect!"
        feedView.resultLabel.textColor = isCorrect ? .systemGreen : .systemRed
    }
}
