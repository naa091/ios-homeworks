//
//  PostTableViewCell.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 04.11.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test title"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Шкет")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.text = "высокий женский головной убор или причёска ◆ Во-о-от, развалили страну демократы, — поправив кандибобер на голове, завела песню одна. Михаил Рябиков, «А вдоль дороги старушки с гастарбайтерами стоят…», 2019 г. // «Комсомольская правда», Москва [Google Книги] ◆ Через остановку вышла женщина в кандибобере, а ещё через пару о происшествии почти забыли. Дмитрий Билик, «Временщик», Книга первая, 2021 г. // «Комсомольская правда», Москва [Google Книги]"
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .systemGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var postLikesLabel: UILabel = {
        let label = UILabel()
        label.text = "Likes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postViewLabel: UILabel = {
    let label = UILabel()
    label.text = "Views"
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
}()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PostTableViewCell {
    func setupCell() {
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(postTextView)
        contentView.addSubview(postLikesLabel)
        contentView.addSubview(postViewLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            postTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            postTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            postTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            postImageView.heightAnchor.constraint(equalToConstant: 250),
            postImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            postImageView.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 16),
            
            postTextView.heightAnchor.constraint(equalToConstant: 100),
            postTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            postTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            postTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            
            postLikesLabel.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 16),
            postLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            postViewLabel.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 16),
            postViewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postViewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
