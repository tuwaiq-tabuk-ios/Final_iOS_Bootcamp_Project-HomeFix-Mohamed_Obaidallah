//
//  AddProfessionalVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 22/05/1443 AH.
//

import UIKit
import FirebaseAuth

class ControlShop: UIViewController {
  
  
  @IBOutlet weak var botDelete: UIButton!
  @IBOutlet weak var butLogout: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func deletePressed(_ sender: Any) {
    
  }
  
  @IBAction func logoutBut(_ sender: Any) {
    let auth = Auth.auth()
    
    do {
      try auth.signOut()
      self.dismiss(animated: true, completion:nil)
      
    } catch let signOutError {
      let alert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
}







