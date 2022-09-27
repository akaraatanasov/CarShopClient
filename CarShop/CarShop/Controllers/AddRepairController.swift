//
//  AddRepairController.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class AddRepairController: UIViewController {

    // MARK: - Dependencies
    
    private let networkManager = NetworkManager.sharedInstance
    private let sharedDataManager = SharedDataManager.sharedInstance
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repairTypeTextField: UITextField!
    @IBOutlet weak var hoursWorkTextField: UITextField!
    @IBOutlet weak var pricePerHourTextField: UITextField!
    
    // MARK: - Properties
    
    var shop: Shop? = nil
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = "Add Repair Details"
        
        // These values should be added by the worker
        hoursWorkTextField.isUserInteractionEnabled = false
        hoursWorkTextField.backgroundColor = .lightGray
        pricePerHourTextField.isUserInteractionEnabled = false
        pricePerHourTextField.backgroundColor = .lightGray
    }
    
    private func addRepairRequest(_ repair: AddRepair, completion: @escaping (Bool) -> Void) {
        networkManager.addRepair(shopId: repair.shopId, repairRequest: repair) { success in
            completion(success)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addRepair(_ sender: Any) {
        guard let date = dateTextField.text, date.isEmpty == false else {
            return // show error
        }
        
        guard let type = repairTypeTextField.text, type.isEmpty == false else {
            return // show error
        }
        
        guard let shopId = shop?.id else {
            return // show error
        }
        
        guard let plateNumber = sharedDataManager.vehiclePlateNumber else {
            return // show error
        }
        
        let repair = AddRepair(id: nil,
                               date: date,
                               repairType: type,
                               shopId: shopId,
                               vehiclePlateNumber: plateNumber,
                               hoursWork: nil,
                               pricePerHour: nil)
        
        addRepairRequest(repair) { [weak self] success in
            guard success else {
                return // show error
            }
            
            // pop two screens so we're on the vehicle details screen
            let vehicleDetailsController = VehicleDetailsController()
            self?.navigationController?.viewControllers = [vehicleDetailsController]
        }
    }
    
}
