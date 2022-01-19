//
//  AddProfessionalVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 22/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase


class ShopOwnerVC: UIViewController {
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var firstNameProfile: UITextField!
  @IBOutlet weak var lastNameProfile: UITextField!
  @IBOutlet weak var emailProfile: UITextField!
  @IBOutlet weak var phoneNumProfile: UITextField!
  @IBOutlet weak var buttonLogout: UIButton!
  @IBOutlet weak var updatButton: UIButton!
 
  
  // MARK: - Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    saveProfile ()
    setUpElements()
  }
  
  
  // MARK: - IBAction
  
  @IBAction func updataProfilePressed(_ sender: UIButton) {
    
    updataProfile()
  }
  
  
  @IBAction func logoutButPressed(_ sender: Any) {
    
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "GoToHouseFixVC")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  // MARK: - Method updataProfile
  
  func updataProfile() {
    
    let userID = Auth.auth().currentUser?.uid
    
    Auth
      .auth()
      .currentUser?
      .updateEmail(to: emailProfile.text!, completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailProfile.text!,
                                       forKey: "email")
        UserDefaults.standard.synchronize()
        getFSCollectionReference(.users)
          .document(userID!).setData([
          "firstName": self.firstNameProfile.text!,
          "lastName": self.lastNameProfile.text!,
          "phoneNumber": self.phoneNumProfile.text!,
        ], merge: true)
      }
    })
  }
  
  
  // MARK: - Method saveProfile
  
  func saveProfile () {
    
    if let user = Auth.auth().currentUser{
      let id = user.uid
      getFSCollectionReference(.users)
        .document(id)
        .getDocument(completion: { result,error in
        if error != nil{
          
          print("~~ Error:\(String(describing: error?.localizedDescription))")
          
        } else {
          if let data = result?.data(){
            self.firstNameProfile.text =
              data["firstName"] as? String
            self.lastNameProfile.text =
              data["lastName"] as? String
            self.phoneNumProfile.text =
              data["phoneNumber"] as? String
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

