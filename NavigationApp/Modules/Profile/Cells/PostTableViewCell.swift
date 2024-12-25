//
//  PostTableViewCell.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 04.11.2024.
//

import UIKit
import SnapKit
import iOSIntPackage

class PostTableViewCell: UITableViewCell {
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test title"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.text = "высокий женский головной убор или причёска ◆ Во-о-от, развалили страну демократы, — поправив кандибобер на голове, завела песню одна. Михаил Рябиков, «А вдоль дороги старушки с гастарбайтерами стоят…», 2019 г. // «Комсомольская правда», Москва [Google Книги] ◆ Через остановку вышла женщина в кандибобере, а ещё через пару о происшествии почти забыли. Дмитрий Билик, «Временщик», Книга первая, 2021 г. // «Комсомольская правда», Москва [Google Книги]"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var postLikesLabel: UILabel = {
        let label = UILabel()
        label.text = "Likes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var postViewLabel: UILabel = {
        let label = UILabel()
        label.text = "Views"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
        processImage(named: "Шкет")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PostTableViewCell {
    func setupCell() {
        contentView.addSubviews(views: [postImageView, postTitleLabel, postTextLabel, postLikesLabel, postViewLabel])
    }
    
    func setupConstraints() {
        postTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        postImageView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(postTitleLabel.snp.bottom).offset(16)
        }
        
        postTextLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(postImageView.snp.bottom).offset(16)
        }
        
        postLikesLabel.snp.makeConstraints { make in
            make.top.equalTo(postTextLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        postViewLabel.snp.makeConstraints { make in
            make.top.equalTo(postTextLabel.snp.bottom).offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func processImage(named imageName: String) {
            guard let sourceImage = UIImage(named: imageName) else {
                print("Изображение \(imageName) не найдено")
                return
            }
            
            let imageProcessor = ImageProcessor() // Создаём экземпляр
        let filter: ColorFilter = .colorInvert // Укажите нужный фильтр
            
            // Обработка изображения
            imageProcessor.processImage(sourceImage: sourceImage, filter: filter) { [weak self] processedImage in
                DispatchQueue.main.async {
                    if let filteredImage = processedImage {
                        self?.postImageView.image = filteredImage // Устанавливаем изображение
                    } else {
                        print("Ошибка обработки изображения")
                    }
                }
            }
        }
}
