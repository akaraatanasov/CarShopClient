//
//  Vehicle.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import Foundation

struct Vehicle: Codable {
    let id: UInt
    let make: String
    let model: String
    let plateNumber: String
    let year: String
}
