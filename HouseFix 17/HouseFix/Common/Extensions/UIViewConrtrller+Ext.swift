//
//  File.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit


extension UIViewController {
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self,
                                     action: #selector(dismissKeyboard))
    
    tap.cancelsTouchesInView = false
    
    view.addGestureRecognizer(tap)
  }
  
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  
  
  func showAlertMessage(title: String,
                        message: String) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Ok",
                               style: .cancel,
                               handler: nil)
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
