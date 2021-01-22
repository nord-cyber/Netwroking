//
//  UserDataModel.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 19.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation

struct UserDataModel {
    var name:String?
    var email:String?
    var id:Int?
    
    init?(dict:[String:Any]) {
        let name = dict["name"] as? String
        let email = dict["email"] as? String
        let id = dict["id"] as? Int
        
        
        self.name = name
        self.email = email
        self.id = id
        
    }
}
