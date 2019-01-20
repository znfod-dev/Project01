//
//  ModelProfile.swift
//  Project01ForZn
//
//  Created by 박종현 on 18/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ModelProfile: NSObject {
    // 개인정보
    // 이름 name
    var name = String()
    // 성 surname
    var surname = String()
    // 주소 address
    var address = String()
    // 폰 phone
    var phone = String()
    // 모바일 mobile
    var mobile = String()
    // 이메일 email
    var email = String()
    
    // WORK
    // 직장주소 work address
    var workAddress = String()
    // 직장전화번호 work phone
    var workPhone = String()
    // 직장이메일 work email
    var workEmail = String()
    
    // FAVOURITES
    // 좋아하는 영화 favourite film
    var favouriteFilm = String()
    // 좋아하는 책 favourite book
    var favouriteBook = String()
    // 좋아하는 음악 favourite music
    var favouriteMusic = String()
    
    override init() {
        super.init()
    }
    convenience init(name:String, surname:String, address:String, phone:String, mobile:String, email:String,
         workAddress:String, workPhone:String, workEmail:String,
         favouriteFilm:String, favouriteBook:String, favouriteMusic:String) {
        self.init()
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
    }
    
}
