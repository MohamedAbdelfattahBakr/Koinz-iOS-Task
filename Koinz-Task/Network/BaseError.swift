//
//  BaseError.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation

enum BaseError: Error {
    case networkError
    case businessError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network Error Message"
        case .businessError(let error):
            return error
        }
    }
}
