//
//  ErrorType.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import Foundation

class ErrorType: Error {
    var localizedDescription: String
    
    init(description: String) {
        localizedDescription = description
    }
}
