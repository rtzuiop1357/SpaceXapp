//
//  DetailCrewCell.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

class DetailCrewCell: BaseCell {

    static let identifier = "CrewCell"
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .headline)
        return view
    }()
    
    lazy var agencyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        return view
    }()
    
    //TODO: UI + configure method
    override func configure<T>(data: T) {
        guard let crew = data as? Crew else { return }
        nameLabel.text = crew.name
        agencyLabel.text = crew.agency
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func addViews() {
        addSubview(nameLabel)
        addSubview(agencyLabel)
        addSubview(imageView)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            agencyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            agencyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            agencyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
}
