//
//  ModelDBProfile.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream
import CloudKit

class ModelDBProfile: BaseObject {
    
    // ID
    @objc dynamic var id = UUID().uuidString
    
    // 개인정보
    // 이름 name
    @objc dynamic var name:String? = nil
    // 성 surname
    @objc dynamic var surname:String? = nil
    // 주소 address
    @objc dynamic var address:String? = nil
    // 폰 phone
    @objc dynamic var phone:String? = nil
    // 모바일 mobile
    @objc dynamic var mobile:String? = nil
    // 이메일 email
    @objc dynamic var email:String? = nil
    
    // WORK
    // 직장주소 work address
    @objc dynamic var workAddress:String? = nil
    // 직장전화번호 work phone
    @objc dynamic var workPhone:String? = nil
    // 직장이메일 work email
    @objc dynamic var workEmail:String? = nil
    
    // FAVOURITES
    // 좋아하는 영화 favourite film
    @objc dynamic var favouriteFilm:String? = nil
    // 좋아하는 책 favourite book
    @objc dynamic var favouriteBook:String? = nil
    // 좋아하는 음악 favourite music
    @objc dynamic var favouriteMusic:String? = nil
    
    // 좋아하는 음악 helloworld
    @objc dynamic var helloworld:String? = nil
    
    // 프로필 사진
    // @objc dynamic var profileImage: CreamAsset?
    
    @objc dynamic var isDeleted = false
    
    convenience init(id:String, name:String, surname:String, address:String, phone:String, mobile:String, email:String, workAddress:String, workPhone:String, workEmail:String, favouriteFilm:String, favouriteBook:String, favouriteMusic:String) {
        self.init()
        self.id = id
        self.name = name
        self.surname = surname
        self.address = address
        self.phone = phone
        self.mobile = mobile
        self.email = email
        self.workAddress = workAddress
        self.workPhone = workPhone
        self.workEmail = workEmail
        self.favouriteFilm = favouriteFilm
        self.favouriteBook = favouriteBook
        self.favouriteMusic = favouriteMusic
        self.helloworld = "helloworld"
    }
    convenience init(profile:ModelProfile) {
        let id = profile.id
        let name = profile.name
        let surname = profile.surname
        let address = profile.address
        let phone = profile.phone
        let mobile = profile.mobile
        let email = profile.email
        let workAddress = profile.workAddress
        let workPhone = profile.workPhone
        let workEmail = profile.workEmail
        let favouriteFilm = profile.favouriteFilm
        let favouriteBook = profile.favouriteBook
        let favouriteMusic = profile.favouriteMusic
        
        self.init(id:id, name: name, surname: surname, address: address, phone: phone, mobile: mobile, email: email, workAddress: workAddress, workPhone: workPhone, workEmail: workEmail, favouriteFilm: favouriteFilm, favouriteBook: favouriteBook, favouriteMusic: favouriteMusic)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 프라이머리키 설정했나?
    override class func isPrimaryKey() -> Bool {
        return (primaryKey() != nil)
    }
    
    // 오브젝트 생성
    override class func createObject(_ dicFields: [String: String]) -> ModelDBProfile {
        let this = self.init()
        
        this.SQLParsing(dicFields)
        
        return this
    }
    
    // 오브젝트 복사후 필드값 세팅
    override class func copyObject(object: Object, dicFields: [String: String]) -> ModelDBProfile {
        let newObject: ModelDBProfile = object.copy() as! ModelDBProfile
        newObject.SQLParsing(dicFields)
        
        return newObject
    }
}

// NSCopying copy기능 처리 해줄려고
extension ModelDBProfile: NSCopying {
    // 클래스 복사
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ModelDBProfile(id: id,
                                  name: name!,
                                  surname: surname!,
                                  address: address!,
                                  phone: phone!,
                                  mobile: mobile!,
                                  email: email!,
                                  workAddress: workAddress!,
                                  workPhone: workPhone!,
                                  workEmail: workEmail!,
                                  favouriteFilm: favouriteFilm!,
                                  favouriteBook: favouriteBook!,
                                  favouriteMusic: favouriteMusic!)
        
        return copy
    }
    
    // SQL 파싱
    func SQLParsing(_ dicFields: [String: String]) {
        
        for key in dicFields.keys {
            // 필드 값 세팅
            self.setField(field: key, value: dicFields[key]!)
        }
    }
    
    // 필드 값 세팅
    func setField(field: String, value: String) {
        
        if field == "id" {
            self.id = value
        }
        else if field == "name" {
            self.name = value
        }
        else if field == "surname" {
            self.surname = value
        }
        else if field == "address" {
            self.address = value
        }
        else if field == "phone" {
            self.phone = value
        }
        else if field == "mobile" {
            self.mobile = value
        }
        else if field == "email" {
            self.email = value
        }
        else if field == "workAddress" {
            self.workAddress = value
        }
        else if field == "workPhone" {
            self.workPhone = value
        }
        else if field == "workEmail" {
            self.workEmail = value
        }
        else if field == "favouriteFilm" {
            self.favouriteFilm = value
        }
        else if field == "favouriteBook" {
            self.favouriteBook = value
        }
        else if field == "favouriteMusic" {
            self.favouriteMusic = value
        }
        else if field == "helloworld" {
            self.helloworld = value
        }
    }
}



extension ModelDBProfile: CKRecordConvertible {
    // Yep, leave it blank!
}

extension ModelDBProfile: CKRecordRecoverable {
    // Leave it blank, too.
}
