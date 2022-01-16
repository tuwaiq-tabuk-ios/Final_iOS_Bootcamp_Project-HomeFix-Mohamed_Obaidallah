//
//  ProfileVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 25/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileVC: UIViewController {
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var firstNameProfile: UITextField!
  @IBOutlet weak var lastNamePro: UITextField!
  @IBOutlet weak var emailPro: UITextField!
  @IBOutlet weak var phoneNumPro: UITextField!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var updateButton: UIButton!
  
  
  // MARK: - View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    saveProfile()
    setUpElements()
  }
  
  
  //MARK: - IBAction
  
  @IBAction func logoutTouch(_ sender: UIButton) {
    logout()
  }
  
  
  @IBAction func UpdateTouch(_ sender: Any) {
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    Auth.auth().currentUser?.updateEmail(to: emailPro.text!,
                                         completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailPro.text!,
                                       forKey: "email")
        UserDefaults.standard.synchronize()
        db.collection("users").document(userID!).setData([
          "firstName" : self.firstNameProfile.text!,
          "lastName" : self.lastNamePro.text!,
          "phoneNumber" : self.phoneNumPro.text!,
        ], merge: true)
      }
    })
  }
  
  // MARK: - Method
  
  func saveProfile () {
    
    let db = Firestore.firestore()
    if let user = Auth.auth().currentUser{
      let id = user.uid
      db.collection("users").document(id).getDocument(completion: { result,
                                                                    error in
        if error != nil{
          print("~~ Error:\(String(describing: error?.localizedDescription))")
        }else{
          if let data = result?.data(){
            self.firstNameProfile.text = data["firstName"] as? String
            self.lastNamePro.text = data["lastName"] as? String
            self.phoneNumPro.text = data["phoneNumber"] as? String
          }
        }
      })
      emailPro.text = user.email
    }
  }
  
  
  func logout(){
    
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "LogIn")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  func setUpElements(){
    Utilities.styleFilledButton(updateButton)
    Utilities.styleTextField(firstNameProfile)
    Utilities.styleTextField(lastNamePro)
    Utilities.styleTextField(emailPro)
    Utilities.styleTextField(phoneNumPro)
    
  }
  
}




