//
//  ShowShopsVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 15/05/1443 AH.
//

import UIKit
import MapKit

class ShowShopsVC: UIViewController,
                   UICollectionViewDelegate,
                   UICollectionViewDataSource,
                   UICollectionViewDelegateFlowLayout {
  
  
  @IBOutlet weak var sandRecustButton: UIButton!
  @IBOutlet weak var coll: UICollectionView!
  @IBOutlet weak var nameShop: UILabel!
  @IBOutlet weak var shopAddresses: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var phoneNumber: UILabel!
  
  var timer : Timer?
  var currnetCellIndex = 0
  
  var showShops : Shop! {
    didSet {
      navigationItem.title = showShops.name
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startTimer()
    Utilities.styleFilledButton(sandRecustButton)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    nameShop.text = showShops.name
    shopAddresses.text = showShops.description
    phoneNumber.text = showShops.phoneNumber
    
  }
  
  
  @IBAction func locationPressted(_ sender: Any) {
    UIApplication.shared.open(URL(string: showShops
                                    .locationLinktextField)!,
                              completionHandler: nil)
  }
  
  
  func startTimer()  {
    timer = Timer.scheduledTimer(timeInterval: 2.5,
                                 target: self,
                                 selector: #selector(nextImage),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if let vc = segue.destination as? SendRequestVC {
      vc.dataRrquest = showShops
    }
    
    
  }
  @objc func nextImage(){
    if currnetCellIndex < showShops.photo.count - 1 {
      currnetCellIndex += 1
    }else{
      currnetCellIndex = 0
    }
    
    coll.scrollToItem(at: IndexPath(item: currnetCellIndex,
                                    section: 0),
                      at: .centeredHorizontally,
                      animated: true)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return showShops.photo.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showImagesCell", for: indexPath) as! ShowShopCollViCell
    
    cell.imgShopsMove.sd_setImage(with: URL(string: showShops.photo[indexPath.row]), placeholderImage: UIImage(named: "home"))
    
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width ,
                  height: collectionView.frame.height )
  }
  
}
