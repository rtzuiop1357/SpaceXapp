//
//  Networking.swift
//  SpaceX
//
//  Created by vojta on 16.02.2022.
//
import Alamofire
import UIKit

class Networking {
    static let shared = Networking()
    
    func getFlightsData(_ completion: @escaping (Result<[Flight],NetworkingError>)->()){
        
        let url = URL(string: "https://api.spacexdata.com/v4/launches/")!
        AF.request(url).response { response in
            guard let data = response.data else {
                completion(.failure(.requestError))
                return
            }
            guard let decodedData = try? JSONDecoder().decode([Flight].self, from: data) else {
                return completion(.failure(.decodingError))
            }
            completion(.success(decodedData))
        }
        
    }
    
    func fetchImagefrom(_ url: URL,_ completion: @escaping(Result<Data,NetworkingError>)->() ) {
        AF.request(url).response { response in
            guard let data = response.data else {
                completion(.failure(.errorFetchingImage))
                return
            }
            completion(.success(data))
        }
    }
    
    func getCrewMember(with id: String,_ completion: @escaping(Result<Crew,NetworkingError>)->()) {
        let url = URL(string: "https://api.spacexdata.com/v4/crew/" + id)!
        AF.request(url).response { response in
            guard let data = response.data else {
                completion(.failure(.requestError))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(Crew.self, from: data) else {
                return completion(.failure(.decodingError))
            }
            
            completion(.success(decodedData))
        }
    }
}
