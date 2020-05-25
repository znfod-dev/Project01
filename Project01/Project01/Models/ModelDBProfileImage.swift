//
//  ModelDBProfileImage.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class ModelDBProfileImage: Object {
    @objc dynamic var uid = NSUUID().uuidString
    @objc dynamic var isDeleted = false
    
    convenience init(uid: String, image: UIImage) {
        self.init()
        
        self.uid = UUID().uuidString
    }
    
    convenience init(profileImage: ModelProfileImage) {
        self.init()
        self.uid = profileImage.uid!
        
        
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
