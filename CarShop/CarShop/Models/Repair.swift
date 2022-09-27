//
//  Repair.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import Foundation

struct Repair: Codable {
    let id: UInt?
    let date: String
    let repairType: String
    let shopId: UInt
    let vehicle: Vehicle
    let hoursWork: Double?
    let pricePerHour: Double?
}

struct AddRepair: Codable {
    let id: UInt?
    let date: String
    let repairType: String
    let shopId: UInt
    let vehiclePlateNumber: String
    let hoursWork: Double?
    let pricePerHour: Double?
}
