//
//  VehicleDetailsController.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class VehicleDetailsController: UIViewController {
    
    // MARK: - Dependencies
    
    private let networkManager = NetworkManager.sharedInstance
    private let sharedDataManager = SharedDataManager.sharedInstance
    
    // MARK: - Outlets
    
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var repairsTableView: UITableView!
    
    // MARK: - Properties
    
    private var vehicle: Vehicle? = nil {
        didSet {
            reloadLabels()
        }
    }
    
    private var vehicleRepairs: [Repair] = [] {
        didSet {
            repairsTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadVehicleData()
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = "Vehicle Repairs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Repair", style: .done, target: self, action: #selector(addRepairTapped))
        
        repairsTableView.dataSource = self
        repairsTableView.delegate = self
    }
    
    private func reloadLabels() {
        makeLabel.text = vehicle?.make
        modelLabel.text = vehicle?.model
        yearLabel.text = vehicle?.year
        licensePlateLabel.text = vehicle?.plateNumber
    }
    
    // MARK: - Network
    
    private func loadVehicleData() {
        guard let plateNumber = sharedDataManager.vehiclePlateNumber else {
            AlertPresenter.sharedInstance.showAlert(from: self,
                                                    withTitle: "Error",
                                                    andMessage: "Invalid plate number!")
            return
        }
        
        loadVehicleDetails(for: plateNumber) { [weak self] in
            self?.loadRepairs(for: plateNumber) {
                print("SUCCESS!")
            }
        }
    }
    
    private func loadVehicleDetails(for plateNumber: String, completion: @escaping () -> Void) {
        networkManager.getVehicleDetails(for: plateNumber) { [weak self] vehicle, error in
            guard let self = self else { return }
            guard let vehicle = vehicle, error == nil else {
                AlertPresenter.sharedInstance.showAlert(from: self,
                                                        withTitle: "Error",
                                                        andMessage: error!.localizedDescription)
                completion()
                return
            }
            self.vehicle = vehicle
            completion()
        }
    }
    
    private func loadRepairs(for plateNumber: String, completion: @escaping () -> Void) {
        networkManager.getRepairs(for: plateNumber) { [weak self] repairs, error in
            guard let self = self else { return }
            guard let repairs = repairs, error == nil else {
                AlertPresenter.sharedInstance.showAlert(from: self,
                                                        withTitle: "Error",
                                                        andMessage: error!.localizedDescription)
                completion()
                return
            }
            self.vehicleRepairs = repairs
            completion()
        }
    }
    
    // MARK: - Actions
    
    @objc func addRepairTapped(){
        let selectShopController = SelectShopController()
        navigationController?.pushViewController(selectShopController, animated: true)
    }

}

extension VehicleDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleRepairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repair = vehicleRepairs[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "repairCell")
        cell.textLabel?.text = repair.repairType
        cell.detailTextLabel?.text = repair.date
        return cell
    }
}

extension VehicleDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let repair = vehicleRepairs[indexPath.row]
//        let repairDetailsController = RepairDetailsController()
//        repairDetailsController.repair = repair
//        navigationController?.pushViewController(repairDetailsController, animated: true)
    }
    
}
