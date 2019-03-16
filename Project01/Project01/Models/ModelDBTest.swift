//
//  ModelDBTest.swift
//  Project01
//
//  Created by 박종현 on 15/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream
import CloudKit

class ModelDBTest: Object {
    @objc dynamic var uid = NSUUID().uuidString
    
    // @objc dynamic var test = NSUUID().uuidString
    
    @objc dynamic var isDeleted = false
    
    convenience init(uid: String) {
        self.init()
        
        self.uid = UUID().uuidString
        // self.test = UUID().uuidString
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

extension ModelDBTest: CKRecordConvertible {
    // Yep, leave it blank!
}

extension ModelDBTest: CKRecordRecoverable {
    // Leave it blank, too.
}
