//
//  OrdersVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class OrderVC: UIViewController ,
               UICollectionViewDelegate ,
               UICollectionViewDataSource {
  
  
  var receivingOrders : [ReceivingOrders] = [ReceivingOrders]()
  
  @IBOutlet weak var orderCollct: UICollectionView!
  
  
  
  // MARK: - View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    orderCollct.delegate = self
    orderCollct.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
  }
  
  
  // MARK: - Action
  
  @IBAction func deleteRequestTouch(_ sender: UIButton) {
    
    let index = sender.tag
    let ind = receivingOrders.firstIndex(of: receivingOrders[index])
    
    getFSCollectionReference(.order)
      .document(receivingOrders[index].id)
      .delete()
    
    receivingOrders.remove(at: ind!)
    orderCollct.reloadData()
  }
  
  
  // MARK: - UICollectionViewDelegate AND UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return receivingOrders.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = orderCollct
      .dequeueReusableCell(withReuseIdentifier: "OrderCell",
                           for: indexPath) as! OrdersCollCell
    
    cell.imageOrder
      .sd_setImage(with: URL(string: receivingOrders[indexPath.row]
                              .image),
                   placeholderImage: UIImage(named: "Image"))
    
    cell.lblPhoneNum.text = receivingOrders[indexPath.row]
      .phoneNum
    
    cell.lblDescription.text = receivingOrders[indexPath.row]
      .description
    
    cell.deleteButton.tag = indexPath.row
    
    return cell
  }
  
  
  // MARK: - Method
  
  func getData() {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    var ID = ""
    
    getFSCollectionReference(.stores)
      .document(auth!.uid)
      .collection("store")
      .getDocuments { snapshot, error in
        if error != nil {
          
        } else {
          
          for document in snapshot!.documents {
            let data = document.data()
            ID = data["id"] as! String
            
            let collectionRF:CollectionReference = db.collection("order")
            collectionRF.getDocuments { [self] snapshot, error in
              if error != nil {
              } else {
                receivingOrders.removeAll()
                for document in snapshot!.documents {
                  let datas = document.data()
                  
                  if document.documentID == ID {
                    for (_,value) in datas {
                      
                      let data = value as! Dictionary<String,Any>
                      
                      let reque = ReceivingOrders(
                        image : data["imgRequest"] as! String,
                        description : data["descrptionTextField"] as! String,
                        phoneNum : data["phoneNumTextField"] as! String,
                        id: data["id"] as! String)
                      
                      receivingOrders.append(reque)
                      orderCollct.reloadData()
                    }
                  }
                }
              }
            }
          }
        }
      }
  }
  
}
