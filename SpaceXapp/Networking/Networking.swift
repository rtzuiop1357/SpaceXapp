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
    
    var activeImageRequests: Set<String> = []
    
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
        guard !activeImageRequests.contains(url.absoluteString) else { return }
        activeImageRequests.insert(url.absoluteString)
        
        AF.request(url).response { response in
            guard let data = response.data else {
                completion(.failure(.errorFetchingImage))
                self.activeImageRequests.remove(url.absoluteString)
                return
            }
            completion(.success(data))
            self.activeImageRequests.remove(url.absoluteString)
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
