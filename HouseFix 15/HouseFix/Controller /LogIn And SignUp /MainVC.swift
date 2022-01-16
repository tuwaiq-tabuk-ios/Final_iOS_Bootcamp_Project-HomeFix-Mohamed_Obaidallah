//
//  MainVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {
  
  
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpElements()
  }
  
  
  func setUpElements() {
    Utilities.styleFilledButton(loginButton)
    Utilities.styleFilledButton(signupButton)
  }
  
}
