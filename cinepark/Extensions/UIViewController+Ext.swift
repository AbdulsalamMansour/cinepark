//
//  UIViewController+Ext.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit
extension UIViewController {
    
    func presentCPAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CPAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
