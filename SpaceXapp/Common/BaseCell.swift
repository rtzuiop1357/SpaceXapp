//
//  BaseCell.swift
//  SpaceXapp
//
//  Created by vojta on 18.03.2022.
//

import UIKit

class BaseCell<T>: UICollectionViewCell {
    init() {
        super.init(frame: .zero)
        addViews()
        addConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() { fatalError() }
    
    func addConstraints() { fatalError() }
    
    func configure(data: T) { fatalError() }
}
