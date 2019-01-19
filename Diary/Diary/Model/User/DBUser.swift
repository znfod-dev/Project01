//
//  DBUser.swift
//  Diary
//
//  Created by Byunsangjin on 11/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import RealmSwift

class DBUser: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var name: String? // 이름
    @objc dynamic var address: String? // 주소
    @objc dynamic var phone: String? // 전화번호
    @objc dynamic var mobile: String? // 휴대폰 번호
    @objc dynamic var email: String? // 이메일
    @objc dynamic var workAddress: String? // 직장 주소
    @objc dynamic var workPhone: String? // 직장 전화번호
    @objc dynamic var workEmail: String? // 직장 이메일
    
    @objc dynamic var favoriteMovie: String? // 좋아하는 영화
    @objc dynamic var favoriteBook: String? // 좋아하는 책
    @objc dynamic var favoriteMusic: String? // 좋아하는 음악
    
    convenience init(name:String, address:String, phone:String, mobile:String, email:String, workAddress:String, workPhone:String, workEamil:String, favoriteMovie:String, favoriteBook:String, favoriteMusic:String) {
        self.init()
        self.name = name
        self.address = address
        self.phone = phone
        self.mobile = mobile
        self.email = email
        self.workAddress = workAddress
        self.workPhone = workPhone
        self.workEmail = workEamil
        
        self.favoriteMovie = favoriteMovie
        self.favoriteBook = favoriteBook
        self.favoriteMusic = favoriteMusic
    }
    
    convenience init(user: User) {
        let name = user.name
        let address = user.address
        let phone = user.phone
        let mobile = user.mobile
        let email = user.email
        let workAddress = user.workAddress
        let workPhone = user.workPhone
        let workEamil = user.workEmail
        
        let favoriteMovie = user.favoriteMovie
        let favoriteBook = user.favoriteBook
        let favoriteMusic = user.favoriteMusic
        
        self.init(name: name!, address: address!, phone: phone!, mobile: mobile!, email: email!, workAddress: workAddress!, workPhone: workPhone!, workEamil: workEamil!, favoriteMovie: favoriteMovie!, favoriteBook: favoriteBook!, favoriteMusic: favoriteMusic!)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
