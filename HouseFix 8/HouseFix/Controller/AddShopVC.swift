//
//  AddShopVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 22/05/1443 AH.
//

import UIKit
import PhotosUI
class AddShopVC: UIViewController,
                 UIImagePickerControllerDelegate ,
                 UINavigationControllerDelegate,
                 UICollectionViewDelegate,
                 UICollectionViewDataSource,
                 PHPickerViewControllerDelegate {
  
  @IBOutlet weak var shopNameTextField: UITextField!
  @IBOutlet weak var imagePhotoShop: UIImageView!
  @IBOutlet weak var collectionVI: UICollectionView!
  
  var arryPhoto = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    collectionVI.delegate = self
    collectionVI.dataSource = self
    
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
  
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: collectionView.frame.width * 0.44,
//                  height: collectionView.frame.height * 0.44)
//  }
  
  
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
  
}
