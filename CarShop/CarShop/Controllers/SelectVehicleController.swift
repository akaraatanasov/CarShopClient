//
//  SelectVehicleController.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class SelectVehicleController: UIViewController {

    // MARK: - Dependencies
    
    private let sharedDataManager = SharedDataManager.sharedInstance
    
    // MARK: - Outlets
    
    @IBOutlet weak var plateNumberTextField: UITextField!
    private var plateNumber: String {
        return plateNumberTextField.text ?? ""
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Vehicle"
    }
    
    // MARK: - Actions
    
    @IBAction func signInTapped(_ sender: Any) {
        guard plateNumber.isEmpty == false,
              plateNumber.count == 8 else {
            AlertPresenter.sharedInstance.showAlert(from: self,
                                                    withTitle: "Error",
                                                    andMessage: "Please enter valid plate number!")
            return
        }
        sharedDataManager.vehiclePlateNumber = plateNumber
        navigationController?.pushViewController(VehicleDetailsController(), animated: true)
    }
    
    @IBAction func addVehicleTapped(_ sender: Any) {
//        navigationController?.pushViewController(AddVehicleController(), animated: true)
    }
}
