//
//  DetailView.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit

class DetailInfoView: BaseView {

    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "lorem iposum"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 30
        label.sizeToFit()

        label.text = "lorem iposum"
        return label
    }()
    
    lazy var failiureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "lorem iposum"
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.text = "18.2.2022"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func addViews() {
        addSubview(stackView)

        stackView.addSubview(nameLabel)
        stackView.addSubview(detailLabel)
        stackView.addSubview(failiureLabel)
        stackView.addSubview(dateLabel)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            
            nameLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 15),
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor,constant: 7),
            
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 7),
            
            failiureLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 15),
            failiureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7),
            failiureLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -15),
            
            detailLabel.topAnchor.constraint(equalTo: failiureLabel.bottomAnchor, constant: 7),
            detailLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15),
            detailLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -15),
            detailLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -30)
        ])
    }
}
