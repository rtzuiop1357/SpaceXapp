//
//  BaseViewModel.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import Foundation
import Combine

class BaseViewModel {
    func configure<T>(data: T) {}
    
    var cancellables: Set<AnyCancellable> = []
}
