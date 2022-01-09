//
//  AddProfessionalVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 22/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase


class ControlShop: UIViewController {
  
  
  @IBOutlet weak var firstNameProfile: UITextField!
  @IBOutlet weak var lastNameProfile: UITextField!
  @IBOutlet weak var emailProfile: UITextField!
  @IBOutlet weak var phoneNumProfile: UITextField!
  @IBOutlet weak var botDelete: UIButton!
  @IBOutlet weak var butLogout: UIButton!
  @IBOutlet weak var updatButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    saveProfile ()
    setUpElements()
  }
  
  
  @IBAction func deletePressed(_ sender: Any) {
    
  }
  
  
  
  @IBAction func updataProfilePressed(_ sender: UIButton) {
    
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    Auth.auth().currentUser?.updateEmail(to: emailProfile.text!,
                                         completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailProfile.text!, forKey: "email")
        UserDefaults.standard.synchronize()
        db.collection("users").document(userID!).setData([
          "firstName": self.firstNameProfile.text!,
          "lastName": self.lastNameProfile.text!,
          "phoneNumber": self.phoneNumProfile.text!,
        ], merge: true)
      }
    })
  }
  
  
  @IBAction func logoutButPressed(_ sender: Any) {
    let auth = Auth.auth()
    
    do {
      try auth.signOut()
      self.dismiss(animated: true, completion:nil)
      
    } catch let signOutError {
      let alert = UIAlertController(title: "Error",
                                    message: signOutError.localizedDescription,
                                    preferredStyle: UIAlertController.Style.alert)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  
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
            self.lastNameProfile.text = data["lastName"] as? String
            self.phoneNumProfile.text = data["phoneNumber"] as? String
          }
        }
      })
      emailProfile.text = user.email
    }
    
    
  }
  func setUpElements(){
    
    Utilities.styleFilledButton(updatButton)
    Utilities.styleTextField(firstNameProfile)
    Utilities.styleTextField(lastNameProfile)
    Utilities.styleTextField(emailProfile)
    Utilities.styleTextField(phoneNumProfile)
  }
  
  
}






