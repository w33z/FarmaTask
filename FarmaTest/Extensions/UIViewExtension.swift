//
//  UIViewExtension.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 29/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIViewController {
    func showAlert(_ message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(dismissAction)
        
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension UISplitViewController {
    var primaryViewController: UIViewController? {
        let navController = self.viewControllers.first as? UINavigationController
        return navController?.viewControllers.first
    }

    var secondaryViewController: UIViewController? {
        return self.viewControllers.count > 1 ? self.viewControllers[1] : nil
    }
}
