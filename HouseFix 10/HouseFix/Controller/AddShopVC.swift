//
//  AddShopVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 22/05/1443 AH.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseAuth

class AddShopVC: UIViewController,
                 UIImagePickerControllerDelegate ,
                 UINavigationControllerDelegate,
                 UICollectionViewDelegate,
                 UICollectionViewDataSource,
                 PHPickerViewControllerDelegate,
                 UIPickerViewDelegate,
                 UIPickerViewDataSource,
                 UITextFieldDelegate {
  
  @IBOutlet weak var shopNameTextField: UITextField!
  @IBOutlet weak var imagePhotoShop: UIImageView!
  @IBOutlet weak var collectionVI: UICollectionView!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var locationLinktextField: UITextField!
  @IBOutlet weak var typeShopTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  
  
  var arryPhoto = [UIImage]()
  let sectionTypeArry = ["Electrical","Plumber","Dyeing","Building"]
  var arryCitys = ["Tabuk","Riyadh","Jeddah","Dammam"]
  var pickerSection = UIPickerView()
  var currentIndex = 0
  var pickerCitys = UIPickerView()
  var toolBarSection:UIToolbar!
  var toolBarCitys:UIToolbar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    setUpElements()
    
    collectionVI.delegate = self
    collectionVI.dataSource = self
    pickerSection.dataSource = self
    pickerSection.delegate = self
    pickerCitys.dataSource = self
    pickerCitys.delegate = self
    typeShopTextField.delegate = self
    
    toolBarSection = UIToolbar()
    toolBarSection.barStyle = UIBarStyle.default
    toolBarSection.isTranslucent = true
    toolBarSection.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(donePickerSection))
    
    toolBarSection.setItems([doneButton], animated: false)
    toolBarSection.isUserInteractionEnabled = true
    
    toolBarCitys = UIToolbar()
    toolBarCitys.barStyle = UIBarStyle.default
    toolBarCitys.isTranslucent = true
    toolBarCitys.sizeToFit()
    
    let doneButton2 = UIBarButtonItem(title: "Done",
                                      style: UIBarButtonItem.Style.plain,
                                      target: self,
                                      action: #selector(donePickerCitys))
    
    toolBarCitys.setItems([doneButton2], animated: false)
    toolBarCitys.isUserInteractionEnabled = true
    
    typeShopTextField.inputView = pickerSection
    typeShopTextField.inputAccessoryView = toolBarSection
    cityTextField.inputView = pickerCitys
    cityTextField.inputAccessoryView = toolBarCitys
  }
  
  
  @objc func donePickerSection() {
    typeShopTextField.text = sectionTypeArry[currentIndex]
    typeShopTextField.resignFirstResponder()
  }
  
  
  @objc func donePickerCitys() {
    cityTextField.text = arryCitys[currentIndex]
    cityTextField.resignFirstResponder()
  }
  
  
  @IBAction func submitBut(_ sender: UIButton) {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    
    var documentID = ""
    if documentID == ""{
      documentID = UUID().uuidString
    }
    
    var imageID = UUID().uuidString
    let imageFolderID = UUID().uuidString
    
    let uploadMetaData = StorageMetadata()
    uploadMetaData.contentType = "image/jpeg"
    
    let type = self.typeShopTextField.text?.lowercased()
    
    let database = db.collection("sections").document(type!)
    let id = database.documentID
    
    database.setData(["\(imageFolderID)": [
      "shopNameTextField":self.shopNameTextField.text!,
      "descriptionTextField":self.descriptionTextField.text!,
      "phoneNumberTextField":self.phoneNumberTextField.text!,
      "locationLinktextField":self.locationLinktextField.text!,
      "typeShopTextField":self.typeShopTextField.text!,
      "cityTextField":self.cityTextField.text!,
      "images":[""],
      "logo": "",
    ]],merge: true) {
      error in guard error == nil else {
        return
      }
    
    db.collection ("stores").document(auth!.uid).collection("store").document(imageFolderID).setData(["id":imageFolderID,"type":type!]) {
      error in guard error == nil else {
        return
      }
    }
    }
    
    let logoImage = self.imagePhotoShop.image?.jpegData(compressionQuality: 0.5)
    
    imageID = UUID().uuidString
    let storageRF = storage.reference().child(auth!.uid).child(imageFolderID).child(imageID)
    storageRF.putData(logoImage!, metadata:uploadMetaData) {
      metadata, error in guard error == nil else {
        return
      }
    
    storageRF.downloadURL { url, error in
      if error != nil {
        
      }else {
        db.collection("sections").document(type!).setData(
          ["\(imageFolderID)":[ "logo": url?.absoluteString]],merge:true, completion: {
            error in guard error == nil else {
              print("-- error: \(error?.localizedDescription)")
              return
            }
          
          print("-- Finish")
          
          } )
      }
    }
    }
    
    var imageData = [Data]()
    
    for image in arryPhoto {
      let data = image.jpegData(compressionQuality: 0.5)
      imageData.append(data!)
    }
    var imageURL = [String]()
    for image in imageData {
      imageID = UUID().uuidString
      
      let storageRF = storage.reference().child(auth!.uid).child(imageFolderID).child(imageID)
      storageRF.putData(image, metadata:uploadMetaData) {
        metadata, error in guard error == nil else {
          return
        }
      
      storageRF.downloadURL { url, error in
        if error != nil {
          
        }else {
          imageURL.append(url!.absoluteString)
          
          db.collection("sections").document(type!).setData(
            ["\(imageFolderID)":["shopNameTextField":self.shopNameTextField.text!,
                                 "descriptionTextField":self.descriptionTextField.text!,
                                 "phoneNumberTextField":self.phoneNumberTextField.text!,
                                 "locationLinktextField":self.locationLinktextField.text!,
                                 "typeShopTextField":self.typeShopTextField.text!,
                                 "cityTextField":self.cityTextField.text!,
                                 "images":imageURL]
            ],
            merge:true, completion: {
              error in guard error == nil else {
                print("-- error: \(error?.localizedDescription)")
                return
              }
            
            print("-- Finish")
            } )
        }
      }
      }
    }
  }
  
  
  @IBAction func takePhoto(_ sender: Any) {
    showPhotoAlert()
  }
  
  
  // Add store photos and the option is either from the photo library or the camera
  func showPhotoAlert(){
    let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
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
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      print("Image Not Found")
      return
    }
    imagePhotoShop.image = image
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  
  // Start adding pictures to the shop
  @IBAction func btnGetPhoto(_ sender: Any) {
    self.arryPhoto.removeAll()
    getPhotos()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arryPhoto.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionVI.dequeueReusableCell(withReuseIdentifier:"photoCell",
                                                for: indexPath) as! PhotoShopViewCell
    cell.imgPhotos.image = arryPhoto[indexPath.row]
    
    return cell
  }
  
  
  func getPhotos(){
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 5
    
    let phPicker = PHPickerViewController(configuration: config)
    phPicker.delegate = self
    present(phPicker, animated: true, completion: nil)
  }
  
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for result in results {
      print("~~ \(results.count)")
      result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
        (imagePic , error) in
        if let imagePice = imagePic as? UIImage {
          DispatchQueue.main.async {
            self.arryPhoto.append(imagePice)
            
            self.collectionVI.reloadData()
          }
          
        }else{
        }
      }
      )
    }
  }
  
  //
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if (pickerView == pickerSection){
      return sectionTypeArry.count
      
    }else {
      return arryCitys.count
    }
    
  }
  
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
    if (pickerView == pickerSection){
      return sectionTypeArry[row]
    }else{
      return arryCitys[row]
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentIndex = row
    if (pickerView == pickerSection){
      typeShopTextField.text = sectionTypeArry[row]
    }else{
      cityTextField.text = arryCitys[row]
    }
  }
  
  
  func setUpElements(){
    Utilities.styleTextField(shopNameTextField)
    Utilities.styleTextField(descriptionTextField)
    Utilities.styleTextField(phoneNumberTextField)
    Utilities.styleTextField(locationLinktextField)
    Utilities.styleTextField(typeShopTextField)
    Utilities.styleTextField(cityTextField)
    Utilities.styleFilledButton(submitButton)
  }
  
  
}
