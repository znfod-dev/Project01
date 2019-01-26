//
//  ModelDBProfile.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class ModelDBProfile: Object {
    
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
    
    convenience init(id:String, name:String, surname:String, address:String, phone:String, mobile:String, email:String, workAddress:String, workPhone:String, workEamil:String, favouriteFilm:String, favouriteBook:String, favouriteMusic:String) {
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
        self.workEmail = workEamil
        self.favouriteFilm = favouriteFilm
        self.favouriteBook = favouriteBook
        self.favouriteMusic = favouriteMusic
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
        
        self.init(id:id, name: name, surname: surname, address: address, phone: phone, mobile: mobile, email: email, workAddress: workAddress, workPhone: workPhone, workEamil: workEmail, favouriteFilm: favouriteFilm, favouriteBook: favouriteBook, favouriteMusic: favouriteMusic)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
