//
//  ViewController.swift
//  HouseFix
//
//  Created by محمد العطوي on 08/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeVC: UIViewController {
  
  
  // MARK: - Properties
  
  var timer : Timer?
  var currnetCellIndex = 0
  var logoImage = [UIImage(named: "Image")!]
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  
  // MARK: - View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    startTimer()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getDataFS()
  }
  
  
  // MARK: -
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
      
    case "shopElectrical":
      if let vc = segue.destination as? SectionsVC {
        var arrayNew:[Shop] = [Shop]()
        shops.forEach { Shops in
          if Shops.type == "Electrical" {
            arrayNew.append(Shops)
          }
        }
        vc.Shops = arrayNew
      }
      
    case "shopPlumber":
      if let vc = segue.destination as? SectionsVC {
        var arrayNew:[Shop] = [Shop]()
        shops.forEach { Shops in
          if Shops.type == "Plumber" {
            arrayNew.append(Shops)
          }
        }
        vc.Shops = arrayNew
      }
      
    case "shopDyeing":
      if let vc = segue.destination as? SectionsVC {
        var arrayNew:[Shop] = [Shop]()
        shops.forEach { Shops in
          if Shops.type == "Dyeing" {
            arrayNew.append(Shops)
          }
        }
        vc.Shops = arrayNew
      }
      
    case "shopBuilding":
      if let vc = segue.destination as? SectionsVC {
        var arrayNew:[Shop] = [Shop]()
        shops.forEach { Shops in
          if Shops.type == "Building" {
            arrayNew.append(Shops)
          }
        }
        vc.Shops = arrayNew
      }
      
    default:
      print("ss")
    }
  }
  
  
  // MARK: - get Data FireStor
  
  func getDataFS() {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let collectionRF:CollectionReference = db.collection("sections")
    
    collectionRF.getDocuments { snapshot, error in
      if error != nil {
        
      } else {
        
        shops.removeAll()
        for document in snapshot!.documents {
          let datas = document.data()
          for (key,value) in datas {
            let data = value as! Dictionary<String,Any>
            let shop = Shop(id: key,
                            name: data["shopNameTextField"] as! String,
                            logo: data["logo"] as! String,
                            photo: data["images"] as! Array,
                            description: data["descriptionTextField"] as! String,
                            locationLinktextField: data["locationLinktextField"] as! String,
                            phoneNumber: data["phoneNumberTextField"] as! String,
                            cities: data["cityTextField"] as! String,
                            type: data["typeShopTextField"] as! String)
            
            shops.append(shop)
            
          }
        }
      }
    }
  }
  
}



extension HomeVC : UICollectionViewDelegate,
                   UICollectionViewDataSource,
                   UICollectionViewDelegateFlowLayout
{
  
  
  // MARK: Move Images
  func startTimer()  {
    timer = Timer.scheduledTimer(timeInterval: 2.5,
                                 target: self,
                                 selector: #selector(nextImage),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  
  @objc func nextImage(){
    
    if currnetCellIndex < logoImage.count - 1 {
      currnetCellIndex += 1
    }else{
      currnetCellIndex = 0
    }
    
    collectionView.scrollToItem(at: IndexPath(item: currnetCellIndex,
                                              section: 0),
                                at: .centeredHorizontally,
                                animated: true)
  }
  
  
  func collectionView(_ collectionView:
                      UICollectionView,
                      numberOfItemsInSection
                      section: Int) -> Int {
    
    return logoImage.count
  }
  
  
  func collectionView(_ collectionView:
                      UICollectionView,
                      cellForItemAt indexPath:
                      IndexPath) -> UICollectionViewCell {
    let cell =
    collectionView
      .dequeueReusableCell(
        withReuseIdentifier: "homeCell",
        for: indexPath) as! HomeCellCollection
    cell.imgCollection.image = logoImage[indexPath.row]
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width,
                  height: collectionView.frame.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  
}
