import UIKit

final class PhotosTableViewCell: UITableViewCell {
    //MARK: - Properties
    private let labelPhotos: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return arrow
    }()
    
    private let stackViewImage: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Init section
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(labelPhotos)
        contentView.addSubview(arrowImage)
        contentView.addSubview(stackViewImage)
        
        setupPreviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("lol")
    }
}

//MARK: - Private extension
private extension PhotosTableViewCell {
    func getPreviewImage(index: Int) -> UIImageView {
        let preview = UIImageView()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.image = Photos.shared.examples[index]
        preview.contentMode = .scaleAspectFill
        preview.layer.cornerRadius = 6
        preview.clipsToBounds = true
        return preview
    }
    
    func setupPreviews() {
        let previews = Array(Photos.shared.examples.prefix(3))
        
        for image in previews {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
            
            stackViewImage.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.previewMinWidth),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: LayoutConstants.imageAspectRatio),
            ])
            
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelPhotos.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.indentTwelve),
            labelPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.indentTwelve),
            labelPhotos.widthAnchor.constraint(equalToConstant: LayoutConstants.labelWidth),
            labelPhotos.heightAnchor.constraint(equalToConstant: LayoutConstants.labelHeight),
            
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.indentTwelve),
            arrowImage.centerYAnchor.constraint(equalTo: labelPhotos.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: LayoutConstants.arrowSize),
            arrowImage.widthAnchor.constraint(equalToConstant: LayoutConstants.arrowSize),
            
            stackViewImage.topAnchor.constraint(equalTo: labelPhotos.bottomAnchor, constant: LayoutConstants.indentTwelve),
            stackViewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.indentTwelve),
            stackViewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.indentTwelve),
            stackViewImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.indentTwelve),
        ])
    }
}
