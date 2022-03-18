//
//  DetailCrewCell.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

class DetailCrewCell: BaseCell {

    static let identifier = "CrewCell"
    
    lazy var image: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title2)
        return view
    }()
    
    lazy var agencyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //TODO: UI + configure method
    override func configure<T>(data: T) {
        guard let crew = data as? Crew else { return }
        nameLabel.text = crew.name
        agencyLabel.text = crew.agency
    }
    
    override func addViews() {
        addSubview(nameLabel)
        addSubview(agencyLabel)
        addSubview(image)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            agencyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            agencyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            agencyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
}
