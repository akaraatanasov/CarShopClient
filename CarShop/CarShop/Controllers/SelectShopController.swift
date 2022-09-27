//
//  SelectShopController.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class SelectShopController: UIViewController {
    
    // MARK: - Dependencies
    
    private let networkManager = NetworkManager.sharedInstance
    private let sharedDataManager = SharedDataManager.sharedInstance
    
    // MARK: - Outlets
    
    @IBOutlet weak var shopsTableView: UITableView!
    
    // MARK: - Properties
    
    private var selectedShop: Shop? = nil
    
    private var shops: [Shop] = [] {
        didSet {
            shopsTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Shop"
        shopsTableView.dataSource = self
        shopsTableView.delegate = self
        loadAllShops()
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = "Select Shop"
        shopsTableView.dataSource = self
        shopsTableView.delegate = self
    }
    
    private func loadAllShops() {
        networkManager.getAllShops { [weak self] shops, error in
            guard let self = self else { return }
            guard let shops = shops, error == nil else {
                AlertPresenter.sharedInstance.showAlert(from: self,
                                                        withTitle: "Error",
                                                        andMessage: error!.localizedDescription)
                return
            }
            self.shops = shops
        }
    }
}

extension SelectShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shop = shops[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "shopCell")
        cell.textLabel?.text = shop.name
        cell.detailTextLabel?.text = "Make: \(shop.make), Expertise: \(shop.expertise)"
        return cell
    }
}

extension SelectShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedShop = shops[indexPath.row]
        let addRepairController = AddRepairController()
        addRepairController.shop = selectedShop
        navigationController?.pushViewController(addRepairController, animated: true)
    }
}
