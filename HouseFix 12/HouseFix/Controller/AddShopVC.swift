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
                 UITextFieldDelegate {
  
  
  // MARK: - Properties
  
  var photos = [UIImage]()
  let sectionTypeArry = ["Electrical", "Plumber", "Dyeing", "Building"]
  var cities = ["Tabuk", "Riyadh", "Jeddah", "Dammam"]
  var pickerSection = UIPickerView()
  var currentIndex = 0
  var pickerCitys = UIPickerView()
  var toolBarSection: UIToolbar!
  var toolBarCitys: UIToolbar!
  var ID: String!
  var typeOld: String!
  
  // MARK: - Outlets
  
  
  @IBOutlet weak var shopNameTextField: UITextField!
  @IBOutlet weak var imagePhotoShop: UIImageView!
  @IBOutlet weak var collectionVI: UICollectionView!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var locationLinktextField: UITextField!
  @IBOutlet weak var typeShopTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  
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
    
    typeShopTextField.inputView = pickerSection
    typeShopTextField.inputAccessoryView = toolBarSection
   
    
    
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
    
    cityTextField.inputView = pickerCitys
    cityTextField.inputAccessoryView = toolBarCitys
    
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    self.collectionRF = db.collection("stores").document(auth.uid).collection("store")
    
  }
  
  var collectionRF:CollectionReference!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    var id = ""
    
    
    
    db.collection("users").document(auth.uid).getDocument { snapshot, error in
      if error != nil {
        
      } else {
        let data = snapshot!.data()!
        
        let hasStore = data["hasStore"] as! Bool
        
        if !hasStore {
          return
        } else {
          
          self.collectionRF.getDocuments { snapshot, error in
            
            if error != nil {
              
            } else {
              
              for document in snapshot!.documents {
                let data = document.data()
                id = data["id"] as! String
                self.typeOld = data["type"] as! String
              }
              
              
              var dataDoc = [String:Any]()
              db.collection("sections").document(self.typeOld).getDocument { snapshot, error in
                if error != nil {
                  
                } else {
                  self.ID = id
                  print("~~ \(self.ID)")
                  let data = snapshot!.data()!
                  
                  dataDoc = data[id] as! [String:Any]
                  
                  self.shopNameTextField.text =  dataDoc["shopNameTextField"] as? String
                  self.imagePhotoShop.sd_setImage(with: URL(string: dataDoc["logo"] as! String), placeholderImage: UIImage(named: ""))
                  self.descriptionTextField.text = dataDoc["descriptionTextField"] as? String
                  self.phoneNumberTextField.text = dataDoc["phoneNumberTextField"] as? String
                  self.locationLinktextField.text = dataDoc["locationLinktextField"] as? String
                  self.typeShopTextField.text = dataDoc["typeShopTextField"] as? String
                  self.cityTextField.text = dataDoc["cityTextField"] as? String
                  
                  for image in dataDoc["images"] as! Array<String> {
                    let imageView = UIImageView()
                    imageView.sd_setImage(with: URL(string: image),placeholderImage: UIImage(named: "home")) { imagee, error, cache, url in
                      self.photos.append(imagee ?? UIImage())
                      print("~~ \(self.photos.count)")
                      self.collectionVI.reloadData()
                    }
                  }
                  self.collectionVI.reloadData()
                }
              }
            }
          }
        }
      }
    }
  }
  
  
  
  @IBAction func takePhotoPressed(_ sender: Any) {
    showPhotoAlert()
  }
  
  
  // Start adding pictures to the shop
  @IBAction func getPhotoPressed(_ sender: Any) {
    self.photos.removeAll()
    getPhotos()
  }
  
  
  @objc func donePickerSection() {
    typeShopTextField.text = sectionTypeArry[currentIndex]
    typeShopTextField.resignFirstResponder()
  }
  
  
  @objc func donePickerCitys() {
    cityTextField.text = cities[currentIndex]
    cityTextField.resignFirstResponder()
  }
  
  
  
  @IBAction func submitPressed(_ sender: UIButton) {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    
    var documentID = ""
    
    if documentID == "" {
      documentID = UUID().uuidString
    }
    
    var imageID = UUID().uuidString
    var imageFolderID:String
    if ID == nil {
      imageFolderID = UUID().uuidString
    } else {
      imageFolderID = ID
    }
    let uploadMetaData = StorageMetadata()
    uploadMetaData.contentType = "image/jpeg"
    
    let type = self.typeShopTextField.text?.lowercased()
    
    if typeOld != type && typeOld != nil {
      
      let document = db.collection("sections").document(typeOld!)
      
      document.updateData([
        self.ID: FieldValue.delete()
      ])
    }
    
    let database = db.collection("sections").document(type!)
    let id = database.documentID
    
    database.setData(["\(imageFolderID)": [
      "shopNameTextField" : self.shopNameTextField.text!,
      "descriptionTextField" : self.descriptionTextField.text!,
      "phoneNumberTextField" : self.phoneNumberTextField.text!,
      "locationLinktextField" : self.locationLinktextField.text!,
      "typeShopTextField" : self.typeShopTextField.text!,
      "cityTextField" : self.cityTextField.text!,
      "images":[""],
      "logo": "",
    ]], merge: true) { error in
      guard error == nil else {
        return
      }
      
      db.collection("stores")
        .document(auth!.uid)
        .collection("store")
        .document(imageFolderID)
        .setData(["id" : imageFolderID,
                  "type" : type!]) { error in
          guard error == nil else {
            return
          }
        }
      
      db.collection("users").document(auth!.uid).setData(["hasStore":true], merge: true)
    }
    
    let logoImage = self.imagePhotoShop.image?.jpegData(compressionQuality: 0.5)
    
    imageID = UUID().uuidString
    
    let storageRF = storage.reference()
      .child(auth!.uid)
      .child(imageFolderID)
      .child(imageID)
    
    storageRF.putData(logoImage!, metadata:uploadMetaData) {
      metadata, error in guard error == nil else {
        return
      }
    
    storageRF.downloadURL { url, error in
      if error != nil {
        
      } else {
        db.collection("sections")
          .document(type!)
          .setData(["\(imageFolderID)":[ "logo": url?.absoluteString]],
                   merge: true,
                   completion: { error in
                    guard error == nil else {
                      print("-- error: \(error?.localizedDescription)")
                      return
                    }
                    
                    print("-- Finish")
                    
                   } )
      }
    }
    }
    
    var imageData = [Data]()
    
    for image in photos {
      let data = image.jpegData(compressionQuality: 0.5)
      imageData.append(data!)
    }
    
    var imageURL = [String]()
    for image in imageData {
      imageID = UUID().uuidString
      
      let storageRF = storage.reference()
        .child(auth!.uid)
        .child(imageFolderID)
        .child(imageID)
      
      storageRF.putData(image, metadata : uploadMetaData) { metadata, error in
        guard error == nil else {
          return
        }
        
        storageRF.downloadURL { url, error in
          if error != nil {
            
          } else {
            imageURL.append(url!.absoluteString)
            
            db.collection("sections").document(type!).setData(
              ["\(imageFolderID)":["shopNameTextField" : self.shopNameTextField.text!,
                                   "descriptionTextField" : self.descriptionTextField.text!,
                                   "phoneNumberTextField" : self.phoneNumberTextField.text!,
                                   "locationLinktextField" : self.locationLinktextField.text!,
                                   "typeShopTextField" : self.typeShopTextField.text!,
                                   "cityTextField" : self.cityTextField.text!,
                                   "images" : imageURL]
              ],
              merge:true, completion: { error in
                guard error == nil else {
                  print("-- error: \(error?.localizedDescription)")
                  return
                }
                
                print("-- Finish")
              })
          }
        }
      }
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(identifier: "mainOrder")
    vc.modalPresentationStyle = .overFullScreen
    
    present(vc , animated: true)
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


// MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension AddShopVC: UIPickerViewDelegate,
                     UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    currentIndex = row
    
    if (pickerView == pickerSection) {
      typeShopTextField.text = sectionTypeArry[row]
    } else {
      cityTextField.text = cities[row]
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String?{
    if (pickerView == pickerSection){
      return sectionTypeArry[row]
    } else {
      return cities[row]
    }
  }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    
    if (pickerView == pickerSection){
      return sectionTypeArry.count
      
    } else {
      return cities.count
    }
  }
}


// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension AddShopVC: UIImagePickerControllerDelegate ,
                     UINavigationControllerDelegate {
  
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
}


// MARK: - PHPickerViewControllerDelegate
extension AddShopVC: PHPickerViewControllerDelegate {
  
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
            self.photos.append(imagePice)
            
            self.collectionVI.reloadData()
          }
          
        } else{
        }
      }
      )
    }
  }
}


// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension AddShopVC:  UICollectionViewDelegate,
                      UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionVI.dequeueReusableCell(withReuseIdentifier:"photoCell",
                                                for: indexPath) as! PhotoShopViewCell
    cell.imgPhotos.image = photos[indexPath.row]
    
    return cell
  }
}
