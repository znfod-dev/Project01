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
    var image: UIImage?
    
    convenience init(uid: String, image: UIImage!) {
        self.init()
        
        self.uid = uid
        self.image = image
    }
    
    convenience init(profileImage: ModelDBProfileImage) {
        let uid = profileImage.uid
        var image:UIImage!
        if let data = profileImage.image?.storedData() {
            image = UIImage(data: data)
        }else {
            image = nil
        }
        self.init(uid: uid, image: image)
    }
}
