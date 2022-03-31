//
//  NetworkingError.swift
//  SpaceXapp
//
//  Created by vojta on 14.03.2022.
//

import Foundation

enum NetworkingError: Error {
    case errorFetchingImage, decodingError, requestError
}
