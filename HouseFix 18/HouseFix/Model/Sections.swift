//
//  SecElectrical.swift
//  HouseFix
//
//  Created by محمد العطوي on 12/05/1443 AH.
//

import UIKit


enum shopType {
  
  case Electrical, Plumber, Dyeing, Building
}


struct Shop {
  var id: String
  var shopName: String
  var logo: String
  var shopPhoto: [String]
  var description: String
  var locationLinktextField: String
  var phoneNumber: String
  var cities: String
  var type: String
 
}

var shops: [Shop] = [Shop]()
  
