//
//  ModelDBProfileImage.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream
import CloudKit

class ModelDBProfileImage: Object {
    @objc dynamic var uid = NSUUID().uuidString
    @objc dynamic var image: CreamAsset?
    @objc dynamic var isDeleted = false
    
    convenience init(uid: String, image: CreamAsset) {
        self.init()
        
        self.uid = UUID().uuidString
        self.image = image
    }
    
    convenience init(profileImage: ModelProfileImage) {
        self.init()
        self.uid = profileImage.uid!
        if let data = profileImage.image?.jpegData(compressionQuality: 1.0) {
            self.image = CreamAsset.create(object: self as CKRecordConvertible, propName: "PROFILEIMAGE", data: data)!
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

extension ModelDBProfileImage: CKRecordConvertible {
    // Yep, leave it blank!
}

extension ModelDBProfileImage: CKRecordRecoverable {
    // Leave it blank, too.
}
