//
//  FSCollectionReference.swift
//  HouseFix
//
//  Created by محمد العطوي on 14/06/1443 AH.
//

import Foundation
import FirebaseFirestore
 
 
enum FSCollectionReference: String {
  case users , order , stores , sections , store
}
 
func getFSCollectionReference(
_ collectionReference: FSCollectionReference
) -> CollectionReference {
  return Firestore.firestore()
    .collection(collectionReference.rawValue)
}
