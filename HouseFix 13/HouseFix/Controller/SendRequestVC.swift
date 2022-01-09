//
//  SendRequestVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 29/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class SendRequestVC: UIViewController ,
                     UIImagePickerControllerDelegate ,
                     UINavigationControllerDelegate{
  
  var dataRrquest : Shop!
  
  @IBOutlet weak var sendButtion: UIButton!
  @IBOutlet weak var lblSandRequest: UILabel!
  @IBOutlet weak var imgRequest: UIImageView!
  @IBOutlet weak var buttonRequest: UIButton!
  @IBOutlet weak var descrptionTextField: UITextField!
  @IBOutlet weak var phoneNumTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    Utilities.styleFilledButton(sendButtion)
  }
  
  
  @IBAction func sandRequestPressed(_ sender: UIButton) {
    sandRequest()
  }
  
  
  @IBAction func getImagePressed(_ sender: UIButton) {
    showPhotoAlert()
  }
  
  
  
  func showPhotoAlert() {
    
    let alert = UIAlertController(title: "Take Photo From:",
                                  message: nil,
                                  preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: "Camera",
                                  style: .default,
                                  handler: { action in
                                    self.getPhoto(type: .camera)
                                  }))
    
    alert.addAction(UIAlertAction(title: "Photo Library",
                                  style: .default,
                                  handler: { action in
                                    self.getPhoto(type: .photoLibrary)
                                  }))
    
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: .cancel,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  
  func getPhoto(type: UIImagePickerController.SourceType){
    let pickerCont = UIImagePickerController()
    pickerCont.sourceType = type
    pickerCont.allowsEditing = false
    pickerCont.delegate = self
    present(pickerCont, animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info:
                              [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      print("Image Not Found")
      return
    }
    imgRequest.image = image
  }
  
  
  func sandRequest() {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    db.collection("order")
      .document(dataRrquest.id)
      .setData([auth.uid:[
                  "phoneNumTextField" :self.phoneNumTextField.text!,
                  "descrptionTextField" : self.descrptionTextField.text!,
                  "id" : dataRrquest.id]], merge: true)
    
    let storage = Storage.storage()
    
    var imageID = UUID().uuidString
    
    let uploadMetaData = StorageMetadata()
    uploadMetaData.contentType = "image/jpeg"
    let logoImage = self.imgRequest.image?.jpegData(compressionQuality: 0.5)
    
    imageID = UUID().uuidString
    
    let storageRF = storage.reference()
      .child(auth.uid)
      .child(imageID)
    
    storageRF.putData(logoImage!, metadata:uploadMetaData) {
      metadata, error in
      
      guard error == nil else {
        return
      }
      
      storageRF.downloadURL { url, error in
        if error != nil {
        } else {
          db.collection("order")
            .document(self.dataRrquest.id)
            .setData([auth.uid:[ "imgRequest" : url?.absoluteString]],
                     merge: true)
          
          let alert = UIAlertController(title: "Done!",
                                        message: "Thank you,the owner will contact you",
                                        preferredStyle: .alert)
          
          let action = UIAlertAction(title: "Ok",
                                     style: .cancel) { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "mainUser")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc , animated: true)
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
}
