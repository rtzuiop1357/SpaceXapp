//
//  DetailViewModelProtocol.swift
//  SpaceXapp
//
//  Created by vojta on 30.03.2022.
//

import Foundation

protocol DetailViewModelProtocol: BaseViewModel<Flight> {
    
    var name: String { get set }
    var detail: String { get set }
    var failiureText: String { get set }
    var dateString: String { get set }
    var images: [ImageObject] { get set }
 
    var id: String { get set }

    func configure(data: Flight)
}

