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
  @IBOutlet weak var lastNameProfile: UITextField!
  @IBOutlet weak var emailProfile: UITextField!
  @IBOutlet weak var phoneNumProfile: UITextField!
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
  
  
  @IBAction func updateProfileTouch(_ sender: Any) {
    
    updateProfile()
  }
  
  
  // MARK: - Method
  
  func saveProfile () {
    
    if let user = Auth.auth().currentUser{
      let id = user.uid
      getFSCollectionReference(FSCollectionReference.users)
        .document(id)
        .getDocument(completion: { authDataResult, error in
        if error != nil{
          
          print("Error:\(String(describing: error?.localizedDescription))")
          
        }else{
          if let data = authDataResult?.data(){
            self.firstNameProfile.text = data["firstName"] as? String
            self.lastNameProfile.text = data["lastName"] as? String
            self.phoneNumProfile.text = data["phoneNumber"] as? String
          }
        }
      })
      emailProfile.text = user.email
    }
  }
  
  
  func updateProfile() {
    
    let userID = Auth.auth().currentUser?.uid
    
    Auth.auth()
      .currentUser?
      .updateEmail(to: emailProfile.text!,
                   completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailProfile.text!,
                                       forKey: "email")
        UserDefaults.standard.synchronize()
        getFSCollectionReference(.users)
          .document(userID!).setData([
          "firstName" : self.firstNameProfile.text!,
          "lastName" : self.lastNameProfile.text!,
          "phoneNumber" : self.phoneNumProfile.text!,
        ], merge: true)
      }
    })
    showAlertMessage(title: "Done!",
                     message: "Your data has been updated")
  }
  
  
  func logout(){
    
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "GoToHouseFixVC")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  func setUpElements(){
    Utilities.styleFilledButton(updateButton)
    Utilities.styleFilledButton(logoutButton)
    Utilities.styleTextField(firstNameProfile)
    Utilities.styleTextField(lastNameProfile)
    Utilities.styleTextField(emailProfile)
    Utilities.styleTextField(phoneNumProfile)
    
  }
  
}




