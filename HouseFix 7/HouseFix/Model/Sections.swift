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
  let name:String
  let logo:UIImage
  let photo:[UIImage]
  let address:String
  let longitude:[CGFloat]!
 // let latitude:CGFloat
  let description:String
  let type:shopType
}


let array:[Shops] = [
  
  // MARK: Electricity Department
  
  Shops(name: "ALShamal Electrical Tools",
        logo: UIImage(named: "alshmal")!,
        photo: [
          UIImage(named: "SH6")!,
          UIImage(named: "SH7")!,
          UIImage(named: "SH8")!,
          UIImage(named: "SH9")!,
        ],
        address: """
  work hours: 8:00 AM at 11:30 PM.
  Address: Prince Fahd bin Sultan,
 Al Faisaliyah South, Tabuk 47911.
 Al Shamal Corporation is proud to have a long history of providing high quality electrical materials. Our exclusive brands: Philips - Nardeen - Roba - ROZ - MAAS ABB styler, one of the largest distributors of Al-Fanar products.
  phone: 014 422 3728
""",
        longitude: [28.238,38.4234],
       // latitude: 38,
        description: "More details click",
        type: .Electrical),
  
  Shops(name: "Electrical1",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude: [28,234],
       // latitude: 35,
        description: "Electrical1 Description",
        type: .Electrical),
  
  Shops(name: "Building",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude: [28,234],
       // latitude: 35,
        description: "Building Description",
        type: .Electrical),
  
  Shops(name: "Dyeing",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude: [28,234],
       // latitude: 35,
        description: "Dyeing Description",
        type: .Electrical),
  
  Shops(name: "Dyeing",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude:[28,234],
       // latitude: 35,
        description: "Dyeing Description",
        type: .Electrical),
  
  Shops(name: "Dyeing",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude:[28,234],
       // latitude: 35,
        description: "Dyeing Description",
        type: .Electrical),
  
  Shops(name: "Dyeing",
        logo: UIImage(named: "home")!,
        photo: [UIImage(named: "H1")!,UIImage(named: "H2")!],
        address: "Shop1 Shop1 Shop1",
        longitude: [28,234],
       // latitude: 35,
        description: "Dyeing Description",
        type: .Electrical),
  
  // END Electricity Department
  
  
  
]
