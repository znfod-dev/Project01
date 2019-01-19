//
//  User.swift
//  Diary
//
//  Created by Byunsangjin on 02/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

class User {
    var name: String? = ""
    var address: String? = ""
    var phone: String? = ""
    var mobile: String? = ""
    var email: String? = ""
    var workAddress: String? = ""
    var workPhone: String? = ""
    var workEmail: String? = ""
    var favoriteMovie: String? = ""
    var favoriteBook: String? = ""
    var favoriteMusic: String? = ""
    
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
    
    convenience init(dbUser: DBUser) {
        
        let name = dbUser.name!
        let address = dbUser.address!
        let phone = dbUser.phone!
        let mobile = dbUser.mobile!
        let email = dbUser.email!
        let workAddress = dbUser.workAddress!
        let workPhone = dbUser.workPhone!
        let workEamil = dbUser.workEmail!
        let favoriteMovie = dbUser.favoriteMovie!
        let favoriteBook = dbUser.favoriteBook!
        let favoriteMusic = dbUser.favoriteMusic!
        
        self.init(name: name, address: address, phone: phone, mobile: mobile, email: email, workAddress: workAddress, workPhone: workPhone, workEamil: workEamil, favoriteMovie: favoriteMovie, favoriteBook: favoriteBook, favoriteMusic: favoriteMusic)
        
    }
}
