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
    func insertProfileImg(profileImg:ModelProfileImage) {
        let dbProfileImg = ModelDBProfileImage.init(profileImage: profileImg)
        try! self.database.write {
            self.database.add(dbProfileImg)
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
            print("new Profile")
            let profile = ModelProfile.init()
            profile.id = UUID().uuidString
            self.insertProfile(profile: profile)
            return profile
        }
    }
    func selectProfileImg() -> ModelProfileImage {
        if let dbProfileImg = self.database.objects(ModelDBProfileImage.self).first {
            let profileImg = ModelProfileImage.init(profileImage: dbProfileImg)
            return profileImg
        }else {
            let profileImg = ModelProfileImage.init()
            profileImg.uid = UUID().uuidString
            self.insertProfileImg(profileImg: profileImg)
            return profileImg
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
    func updateProfileImage(profileImg:ModelProfileImage) {
        let dbProfileImg = ModelDBProfileImage.init(profileImage: profileImg)
        try! self.database.write {
            self.database.add(dbProfileImg, update: true)
        }
    }
    
    // Delete
    func deleteProfileIniCloud() {
        
    }
    
    func deleteProfileImageIniCloud() -> Bool{
        if let dbProfileImg = self.database.objects(ModelDBProfileImage.self).first {
            
            return true
        }else {
            return false
        }
    }
    
}
