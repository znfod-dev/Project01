//
//  ModelProfileImage.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ModelProfileImage: NSObject {
    var uid: String?
    
    convenience init(uid: String) {
        self.init()
        
        self.uid = uid
    }
    
    convenience init(profileImage: ModelDBProfileImage) {
        let uid = profileImage.uid
        
        self.init(uid: uid)
    }
}
