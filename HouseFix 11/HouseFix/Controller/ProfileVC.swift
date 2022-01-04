//
//  ProfileVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 25/05/1443 AH.
//

import UIKit
import FirebaseAuth
class ProfileVC: UIViewController {
  
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imgProfile.layer.borderWidth = 1
    imgProfile.layer.masksToBounds = false
    imgProfile.layer.borderColor = UIColor.black.cgColor
    imgProfile.layer.cornerRadius = imgProfile.frame.height/4
    imgProfile.clipsToBounds = true
    
  }
  
  
  @IBAction func logoutTouch(_ sender: UIButton) {
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

