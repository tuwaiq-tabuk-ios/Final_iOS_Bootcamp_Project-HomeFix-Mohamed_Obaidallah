//
//  ShowShopsVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 15/05/1443 AH.
//

import UIKit
import MapKit


class ShowShopsVC: UIViewController {
  
  
  // MARK: - Properties
  
  var timer : Timer?
  var currnetCellIndex = 0
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var sandRecustButton: UIButton!
  @IBOutlet weak var CollectionView: UICollectionView!
  @IBOutlet weak var nameShop: UILabel!
  @IBOutlet weak var shopAddresses: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  
  var showShops : Shop! {
    didSet {
      navigationItem.title = showShops.shopName
    }
  }
  
  
  // MARK: - View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startTimer()
    Utilities.styleFilledButton(sandRecustButton)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    nameShop.text = showShops.shopName
    shopAddresses.text = showShops.description
    phoneNumberLabel.text = showShops.phoneNumber
    
  }
  
  
  // MARK: - Action
  
  @IBAction func locationPressted(_ sender: Any) {
    UIApplication.shared.open(URL(string: showShops
                                    .locationLinktextField)!,
                              completionHandler: nil)
  }
  
  
  // MARK: - Method
  
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
    if currnetCellIndex < showShops.shopPhoto.count - 1 {
      currnetCellIndex += 1
    }else{
      currnetCellIndex = 0
    }
    
    CollectionView.scrollToItem(at: IndexPath(item: currnetCellIndex,
                                              section: 0),
                                at: .centeredHorizontally,
                                animated: true)
  }
  
  
}


// MARK: - UICollectionViewDelegate AND UICollectionViewDataSource AND UICollectionViewDelegateFlowLayout


extension ShowShopsVC : UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout {
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return showShops.shopPhoto.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showImagesCell",
                                                  for: indexPath) as! ShowShopCollViCell
    
    cell.imageShopsMove.sd_setImage(with: URL(string: showShops.shopPhoto[indexPath.row]),
                                    placeholderImage: UIImage(named: "home"))
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.height,
                  height: collectionView.frame.height )
  }
  
  
}
