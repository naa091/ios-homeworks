import UIKit
import AVFoundation

final class AudioPlayerViewController: UIViewController {

    private var player: AVAudioPlayer?
    private var currentTrackIndex = 0
    private let trackNames = ["testSound1", "testSound2", "testSound3", "testSound4", "testSound5"]
    private var timer: Timer?

    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track Name"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    private lazy var previousButton = createControlButton(title: "⏮️", action: #selector(previousTrack))
    private lazy var playPauseButton = createControlButton(title: "▶️", action: #selector(playPauseTapped))
    private lazy var stopButton = createControlButton(title: "⏹️", action: #selector(stopTapped))
    private lazy var nextButton = createControlButton(title: "⏭️", action: #selector(nextTrack))

    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.progress = 0
        return pv
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00 / 0:00"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private lazy var controlStackTop: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, stopButton, nextButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var trackButtons: [UIButton] = trackNames.enumerated().map { index, name in
        let button = createTrackButton(title: "Track \(index + 1)", tag: index)
        return button
    }

    private lazy var trackStackBottom: UIStackView = {
        let stack = UIStackView(arrangedSubviews: trackButtons)
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Audio Player"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        loadTrack(at: currentTrackIndex)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Setup
    private func setupUI() {
        [titleLabel, progressView, timeLabel, controlStackTop, trackStackBottom].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            timeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            controlStackTop.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            controlStackTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            controlStackTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            controlStackTop.heightAnchor.constraint(equalToConstant: 50),

            trackStackBottom.topAnchor.constraint(equalTo: controlStackTop.bottomAnchor, constant: 20),
            trackStackBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackStackBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackStackBottom.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func createControlButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func createTrackButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(trackButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    // MARK: - Track Logic
    private func loadTrack(at index: Int) {
        guard let url = Bundle.main.url(forResource: trackNames[index], withExtension: "m4a") else {
            print("Failed to load track \(trackNames[index])")
            return
        }

        do {
            player?.stop()
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            titleLabel.text = "Track \(index + 1): \(trackNames[index])"
            playPauseButton.setTitle("▶️", for: .normal)
            updateProgress()
        } catch {
            print("Error loading audio: \(error)")
        }
    }

    private func updateProgress() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.refreshProgress()
        }
    }

    private func refreshProgress() {
        guard let player = player else { return }

        let current = player.currentTime
        let duration = player.duration

        progressView.progress = Float(current / duration)

        let currentText = formatTime(current)
        let durationText = formatTime(duration)
        timeLabel.text = "\(currentText) / \(durationText)"
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Actions
    @objc private func playPauseTapped() {
        guard let player = player else { return }

        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("▶️", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("⏸️", for: .normal)
        }
    }

    @objc private func stopTapped() {
        guard let player = player else { return }
        player.stop()
        player.currentTime = 0
        refreshProgress()
        playPauseButton.setTitle("▶️", for: .normal)
    }

    @objc private func previousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + trackNames.count) % trackNames.count
        loadTrack(at: currentTrackIndex)
    }

    @objc private func nextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % trackNames.count
        loadTrack(at: currentTrackIndex)
    }

    @objc private func trackButtonTapped(_ sender: UIButton) {
        currentTrackIndex = sender.tag
        loadTrack(at: currentTrackIndex)
    }
}

