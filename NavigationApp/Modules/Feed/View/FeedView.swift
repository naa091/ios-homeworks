import UIKit
import SnapKit

final class FeedView: UIView {
    
    // MARK: - Public UI Elements
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your guess"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Waiting for input..."
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Actions
    var onOpenPostTapped: (() -> Void)?
    var onTestTapped: (() -> Void)?
    var onCheckTapped: (() -> Void)?
    var onAudioPlayerTapped: (() -> Void)?
    var onInfoTapped: (() -> Void)?
    
    // MARK: - Buttons
    private lazy var infoButton = CustomButton(
        title: "Open Info",
        titleColor: .white,
        backgroundColor: .systemTeal,
        cornerRadius: 10
    ) { [weak self] in
        self?.onInfoTapped?()
    }
    
    private lazy var audioPlayerButton = CustomButton(
        title: "Audio Player",
        titleColor: .white,
        backgroundColor: .darkGray,
        cornerRadius: 10
    ) { [weak self] in
        self?.onAudioPlayerTapped?()
    }

    private lazy var openPostButton = CustomButton(
        title: "Open post",
        titleColor: .white,
        backgroundColor: .red,
        cornerRadius: 10
    ) { [weak self] in
        self?.onOpenPostTapped?()
    }
    
    private lazy var testButton = CustomButton(
        title: "Test button",
        titleColor: .white,
        backgroundColor: .purple,
        cornerRadius: 10
    ) { [weak self] in
        self?.onTestTapped?()
    }
    
    private lazy var checkGuessButton = CustomButton(
        title: "Check",
        titleColor: .white,
        backgroundColor: .systemBlue
    ) { [weak self] in
        self?.onCheckTapped?()
    }
    
    // MARK: - Stack
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            openPostButton,
            testButton,
            textField,
            checkGuessButton,
            resultLabel,
            audioPlayerButton,
            infoButton
        ])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension
private extension FeedView {
    func setupView() {
        addSubview(verticalStackView)
    }

    func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        [openPostButton, testButton, checkGuessButton].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(50) }
        }

        textField.snp.makeConstraints { $0.height.equalTo(44) }
        resultLabel.snp.makeConstraints { $0.height.equalTo(30) }
        audioPlayerButton.snp.makeConstraints { $0.height.equalTo(50) }
        infoButton.snp.makeConstraints { $0.height.equalTo(50) }
    }
}
