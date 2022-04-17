//
//  MainViewModel.swift
//  SpaceX
//
//  Created by vojta on 02.03.2022.
//

import UIKit
import Combine

final class MainViewModel: BaseViewModel<Any>, MainViewModelProtocol {
    
    var filterByImagePublisher: Published<Bool>.Publisher { $filterByImage }
    var searchCollectionPublisher: Published<[Flight]>.Publisher { $searchCollectionOfFlights }
    
    var sorted = ComparisonResult.orderedDescending
    
    fileprivate var idsOfFlights: [Flight] = []
    
    @Published var filterByImage: Bool
        
    @Published var searchCollectionOfFlights: [Flight] = []
    
    //custom image storage used for storing images that are shared between multiple views...
    let imageStorage = ImageStorage.shared
    
    override init() {
        filterByImage = UserDefaults.standard.filterByImage
        
        super.init()

        bind()
    }
    
    func bind() {
        $filterByImage.sink { val in
            UserDefaults.standard.filterByImage = val
        }.store(in: &cancellables)
    }
    
    func search(text: String) {
        let filter1: (Flight)->(Bool) = {
            return $0.name.lowercased().contains(text.lowercased())
        }
        let filter2: (Flight)->(Bool) = {
            return !$0.links.images.original.isEmpty && $0.name.lowercased().contains(text.lowercased())
        }
        
        searchCollectionOfFlights = idsOfFlights.filter {
            return filterByImage ? filter2($0) : filter1($0)
        }
    }
    
    func clearSearch() {
        updateData(sort: false)
    }
    
    func updateData(sort: Bool) {
        let flight = idsOfFlights
        
        //Sorting data
        let flights = !sort ? flight : flight.sorted {
            $0.getDate.compare($1.getDate) == sorted
        }
        
        let filteredFlights = !filterByImage ? flights : flights.filter { item in
            !item.links.images.original.isEmpty
        }
        searchCollectionOfFlights = []
        searchCollectionOfFlights = filteredFlights
        idsOfFlights = flights
    }
    
    func downloadImage(from link: String, completion: @escaping(UIImage) -> Void) {
        //sets placeholder as current image of the cell
        let url = URL(string: link)!
        Networking.shared.fetchImagefrom(url) { [weak self] data in
            guard let self = self else { return }
            switch data {
            case .failure(let error):
                print(error)
            case .success(let data):
                let size = UIScreen.main.bounds.size
                
                //after the image is recived this code recieves it and tels the cell
                //where it belongs to rerender
                if let image = UIImage(data: data)?
                    .scalePreservingAspectRatio(targetSize: size) {
                    self.imageStorage.store(image, for: link)
                    completion(image)
                }
            }
        }
    }
    
    func handleRefresh(_ completion: @escaping()-> Void) {
        idsOfFlights = []
        imageStorage.clear()

        Networking.shared.getFlightsData{ [weak self] data in
            switch data {
            case.success(let flightsData):
                guard let self = self else { return }
                self.idsOfFlights = flightsData
                self.updateData(sort: true)
                completion()
            case .failure(let error):
                print("\(Date()) - failiure: \(error)")
            }
        }
    }
    
    func setInitialData() {
        Networking.shared.getFlightsData{ [weak self] data in
            switch data {
            case.success(let flightsData):
                guard let self = self else { return }
                self.idsOfFlights = flightsData
                self.updateData(sort: true)
            case .failure(let error):
                print("\(Date()) - failiure: \(error)")
            }
        }
    }
}
