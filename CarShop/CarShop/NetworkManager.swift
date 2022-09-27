//
//  NetworkManager.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    // MARK: - Vars
    
    let baseUrl = "http://localhost:8080/v1/"
    
    // MARK: - Vehicle
    
    func getVehicleDetails(for vehiclePlateNumber: String, completionHandler: @escaping (_ vehicle: Vehicle?, _ error: Error?) -> ()) {
        let path = "vehicles/\(vehiclePlateNumber)"
        let urlString = baseUrl + path
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString),
               let data = try? Data(contentsOf: url),
               let vehicle = try? JSONDecoder().decode(Vehicle.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(vehicle, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, ErrorType(description: "Listing items was unsuccessful"))
                }
            }
        }
    }
    
    func getRepairs(for vehiclePlateNumber: String, completionHandler: @escaping (_ repairs: [Repair]?, _ error: Error?) -> ()) {
        let path = "vehicles/\(vehiclePlateNumber)/repairs"
        let urlString = baseUrl + path
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString),
               let data = try? Data(contentsOf: url),
               let repairs = try? JSONDecoder().decode([Repair].self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(repairs, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, ErrorType(description: "Listing items was unsuccessful"))
                }
            }
        }
    }
    
    // MARK: - Shop
    
    func getAllShops(completionHandler: @escaping (_ shops: [Shop]?, _ error: Error?) -> ()) {
        let path = "shops"
        let urlString = baseUrl + path
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString),
               let data = try? Data(contentsOf: url),
               let shops = try? JSONDecoder().decode([Shop].self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(shops, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, ErrorType(description: "Listing items was unsuccessful"))
                }
            }
        }
    }
    
    // MARK: - Repair
    
    func addRepair(shopId: UInt, repairRequest: AddRepair, completionHandler: @escaping (_ success: Bool) -> ()) {
        let path = "shops/\(shopId)/repairs"
        let urlString = baseUrl + path
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpBody = try? repairRequest.data()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(false)
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
        }
        task.resume()
    }
}
