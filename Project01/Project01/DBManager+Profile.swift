//
//  DBManager+Profile.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
extension DBManager {
    
    // Insert
    func insertProfile(profile:ModelProfile) {
        let dbProfile = ModelDBProfile.init(profile: profile)
        print("insertProfile : \(dbProfile)")
        try! self.database.write {
            self.database.add(dbProfile)
        }
    }
    // Select
    func selectProfile() -> ModelProfile {
        print("selectProfile")
        if let dbProfile = self.database.objects(ModelDBProfile.self).first {
            print("dbProfile : \(dbProfile)")
            let profile = ModelProfile.init(dbProfile: dbProfile)
            return profile
        }else {
            let profile = ModelProfile.init()
            profile.id = UUID().uuidString
            self.insertProfile(profile: profile)
            return profile
        }
    }
    // Update
    func updateProfile(profile:ModelProfile) {
        print("updateProfile")
        let dbProfile = ModelDBProfile.init(profile: profile)
        print("dbProfile : \(dbProfile)")
        try! self.database.write {
            self.database.add(dbProfile, update: true)
        }
    }
    
}
