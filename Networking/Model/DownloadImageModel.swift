//
//  DownloadImageModel.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 4.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation
import UIKit

struct DownloadImage {
    
    let key:String
    let data:Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else {return nil}
        self.data = data
    }
}
