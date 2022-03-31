//
//  BaseViewModel.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import Foundation
import Combine

class BaseViewModel<T> {
    func configure(data: T) {}
    
    var cancellables: Set<AnyCancellable> = []
}
