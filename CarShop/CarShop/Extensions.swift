//
//  Extensions.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Encodable {
    func data(using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func string(using encoder: JSONEncoder = JSONEncoder()) throws -> String {
        return try String(data: encoder.encode(self), encoding: .utf8)!
    }
}
