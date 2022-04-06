//
//  MainCollectionViewCell.swift
//  SpaceX
//
//  Created by vojta on 16.02.2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "cell"
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 30
        label.sizeToFit()

        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     private func setupConstraints() {
         NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -25),
            mainImageView.heightAnchor.constraint(equalTo: heightAnchor,constant: -90),
            
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor,constant: 7),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7)
         ])
    }

    private func setupViews() {
        addSubview(mainImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
}
