//
//  FeedViewController.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    var coordinator: FeedCoordinator?
    
    private let viewModel = FeedViewModel()
    private let feedView = FeedView()
    
    override func loadView() {
        feedView.onOpenPostTapped = { [weak self] in self?.coordinator?.openPost(withColor: .systemOrange) }
        feedView.onTestTapped = { [weak self] in self?.coordinator?.openPost(withColor: .systemMint) }
        feedView.onCheckTapped = { [weak self] in self?.checkGuess() }
        feedView.onAudioPlayerTapped = { [weak self] in self?.coordinator?.openAudioPlayer() }

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
}
