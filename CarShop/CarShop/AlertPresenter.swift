//
//  AlertPresenter.swift
//  CarShop
//
//  Created by Alexander Karaatanasov on 27.09.22.
//

import UIKit

class AlertPresenter {
    
    static let sharedInstance = AlertPresenter()
    
    func showAlert(from sender: UIViewController, withTitle title: String, andMessage message: String, buttonHandler handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        sender.present(alertController, animated: true)
    }
    
}
