//
//  MainVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit

class MainVC: UIViewController {

  @IBOutlet weak var loginBut: UIButton!
  
  @IBOutlet weak var signupBut: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      setUpElements()
      
    }
  
  func setUpElements(){
    
    Utilities.styleHollowButton(loginBut)
    Utilities.styleHollowButton(signupBut)
    
  }
  
}
