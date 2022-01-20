//
//  SectionsControl.swift
//  HouseFix
//
//  Created by محمد العطوي on 12/05/1443 AH.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth


class SectionsVC : UIViewController,
                        UICollectionViewDelegate,
                        UICollectionViewDataSource {
  
  // MARK: - Properties
  
  var Shops:[Shop]!
  var selectedShop:Shop!
  
  
  @IBOutlet weak var shopsCollectionView: UICollectionView!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  // MARK: - UICollectionViewDelegate AND UICollectionViewDataSource
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return Shops.count
  }
  
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell =
      collectionView.dequeueReusableCell(
        withReuseIdentifier: "cell",
        for: indexPath) as! ShopViewCell
    
    cell.imageShop.sd_setImage(with: URL(string: Shops[indexPath.row].logo),
                                placeholderImage: UIImage(named: "home"))
    cell.name.text = Shops[indexPath.row].shopName
    cell.descriptionShop.text = Shops[indexPath.row].cities
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width,
                  height: collectionView.frame.height)
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    selectedShop = Shops[indexPath.row]
    
    return true
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ShowShopsVC {
      vc.showShops = selectedShop
    }
  }
  
  
}
