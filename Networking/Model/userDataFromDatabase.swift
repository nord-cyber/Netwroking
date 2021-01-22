//
//  userDataFromDatabase.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 20.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation


struct FromDatabase {
    var name:String
    var email:String
    
    
    init?(data:[String:Any]) {
        guard  let name = data["name"] as? String,  let email = data["email"] as? String else {return nil}
        
        self.name = name
        self.email = email
    }
}
