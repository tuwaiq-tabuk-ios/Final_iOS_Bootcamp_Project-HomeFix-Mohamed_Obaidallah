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
  
  @IBOutlet weak var coll: UICollectionView!
  @IBOutlet weak var nameShop: UILabel!
  @IBOutlet weak var shopAddresses: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  var timer : Timer?
  var currnetCellIndex = 0
  var showShops : Shops! {
    didSet {
      navigationItem.title = showShops.name
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startTimer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    nameShop.text = showShops.name
    shopAddresses.text = showShops.address
    
    mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(showShops.longitude[1]), longitude: CLLocationDegrees(showShops.longitude[0])), latitudinalMeters: CLLocationDistance(100), longitudinalMeters: CLLocationDistance(100)), animated: true)
    
    let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(showShops.longitude[0]), longitude: CLLocationDegrees(showShops.longitude[1]))
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coords
    mapView.addAnnotation(annotation)
    
    mapView.mapType = .standard
    
  }
  
  
  func startTimer()  {
    timer = Timer.scheduledTimer(timeInterval: 2.5,
                                 target: self,
                                 selector: #selector(nextImage),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  
  @objc func nextImage(){
    if currnetCellIndex < showShops.photo.count - 1 {
      currnetCellIndex += 1
    }else{
      currnetCellIndex = 0
    }

      coll.scrollToItem(at: IndexPath(item: currnetCellIndex, section: 0), at: .centeredHorizontally, animated: true)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return showShops.photo.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showImagesCell", for: indexPath) as! ShowShopCollViCell
    
    cell.imgShopsMove.image = showShops.photo[indexPath.row]
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width ,
                  height: collectionView.frame.height )
  }
 
  
}
