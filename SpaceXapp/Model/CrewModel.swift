//
//  CrewModel.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import Foundation

struct Crew: Codable, Identifiable {
    let id: String
    let name: String
    let image: String
    let agency: String
}
