//
//  ReceivingOrders.swift
//  HouseFix
//
//  Created by محمد العطوي on 01/06/1443 AH.
//

import UIKit

class ReceivingOrders : Equatable {
  

  var image : String
  var description : String
  var phoneNum : String
  var id : String
  
  init(image : String,
       description : String,
       phoneNum : String,
       id : String) {
    
    self.image = image
    self.description = description
    self.phoneNum = phoneNum
    self.id = id
  }
  
  
  static func == (lhs: ReceivingOrders,
                  rhs: ReceivingOrders)-> Bool{
    
    return lhs.image == rhs.image
      && lhs.description == rhs.description
      && lhs.phoneNum == rhs.phoneNum
      && lhs.id == rhs.id
  }
  
  
}


