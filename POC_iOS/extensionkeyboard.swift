//
//  extensionkeyboard.swift
//  POC_iOS
//
//  Created by Hany Arafa on 12/3/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import Foundation
import Swift
import UIKit

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
