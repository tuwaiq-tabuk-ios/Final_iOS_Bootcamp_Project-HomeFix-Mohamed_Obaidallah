//
//  SecElectrical.swift
//  HouseFix
//
//  Created by محمد العطوي on 12/05/1443 AH.
//

import UIKit


enum shopType {
  case Electrical,Plumber,Dyeing,Building
}

// MARK: 
struct Shops {
  var id:String
  var name:String
  var logo:String
  var photo:[String]
  var description:String
  var location:String
//  let longitude:[CGFloat]!
//  let latitude:CGFloat
  var phoneNumber : String
  var cities:String
  var type:String
}


var array:[Shops] = [Shops]()
  
