import UIKit

final class CustomButton: UIButton {
    var action: (() -> Void)?

    init(title: String, titleColor: UIColor = .white, backgroundColor: UIColor = .blue, cornerRadius: CGFloat = 8.0, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.action = action
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        action?()
    }

    func updateStyle(title: String?, titleColor: UIColor?, backgroundColor: UIColor?, cornerRadius: CGFloat?) {
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        if let titleColor = titleColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
