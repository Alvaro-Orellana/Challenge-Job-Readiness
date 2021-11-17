//
//  Alert.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 15/11/2021.
//

import UIKit

struct Alert {
    static func show(on viewController: UIViewController, title: String, message: String) {
        // Create basic alert and add OK button
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        viewController.present(alert, animated: true)
        
    }
}

