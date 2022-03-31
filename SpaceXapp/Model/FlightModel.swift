//
//  FlightModel.swift
//  SpaceXapp
//
//  Created by vojta on 14.03.2022.
//

import Foundation

struct Flight: Identifiable, Codable {
    
    //MARK: - DateFormatters
    //Formaters are expensive to build so there is static instance
    //so we use only one formtatter and not createing one formatter
    //for every single date that we need to convert
    static let fromStringToDateFormater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        return dateFormater
    }()
    
    //MARK: - Propeties
    let name: String
    private let date: String
        
    let details: String?
    let crew: [String]
    let success: Bool?
    let links: Links
    let failures: [Failiure]
    
    let id: String
    
    //MARK: - dates
    var formatedDate: String {
        //2020-05-30T19:22:00.000Z
        let date = Flight.fromStringToDateFormater.date(from: date)! // replace Date String
        return Flight.shortDateFormatter.string(from: date)
    }
    
    var getDate: Date {
        return Flight.fromStringToDateFormater.date(from: date)!
    }
    
    //MARK: - Coding keys
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case date = "date_utc"
        case links = "links"
        case details = "details"
        case success = "success"
        case failures = "failures"
        case crew = "crew"
        case id = "id"
    }
}

struct Failiure: Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}

struct FlickerImages: Codable {
    let original: [String]
}

struct Links: Codable {
    let images: FlickerImages
    let wikipedia: String?
    
    enum CodingKeys: String, CodingKey {
        case images = "flickr"
        case wikipedia = "wikipedia"
    }
}
