//
//  SectionsControl.swift
//  HouseFix
//
//  Created by محمد العطوي on 12/05/1443 AH.
//

import UIKit

class SectionsControl : UIViewController,
                        UICollectionViewDelegate,
                        UICollectionViewDataSource {
  
  var arrayShop:[Shops]!
  var selectedShop:Shops!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return arrayShop.count
  }
  
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                         for: indexPath) as! ShopViewCell
    
    cell.imageShops.image = arrayShop[indexPath.row].logo
    cell.name.text = arrayShop[indexPath.row].name
    cell.descriptioN.text = arrayShop[indexPath.row].description
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width,
                  height: collectionView.frame.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    selectedShop = arrayShop[indexPath.row]
    
    return true
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ShowShopsVC {
      vc.showShops = selectedShop
    }
  }
  
  
}
