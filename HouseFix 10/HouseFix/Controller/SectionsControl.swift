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

struct Section {
  let name: String
  let image: String
  let stores: [Shops]
}
class SectionsControl : UIViewController,
                        UICollectionViewDelegate,
                        UICollectionViewDataSource {
  
  var arrayShop:[Shops]!
  var selectedShop:Shops!
  var array:[Shops] = [Shops]()
  @IBOutlet weak var shopsCollectionView: UICollectionView!
  
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
    
    cell.imageShops.sd_setImage(with: URL(string: arrayShop[indexPath.row].logo), placeholderImage: UIImage(named: "home"))
    cell.name.text = arrayShop[indexPath.row].name
    cell.descriptioN.text = arrayShop[indexPath.row].cities
    
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
