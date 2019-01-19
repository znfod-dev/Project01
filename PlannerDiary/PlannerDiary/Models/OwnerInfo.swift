//
//  OwnerInfo.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 17..
//  Copyright © 2019년 sama73. All rights reserved.
//
// 다이어리 소유권자 정보

import UIKit
import RealmSwift

// NSCopying copy기능 처리 해줄려고
class OwnerInfo: Object, NSCopying {
    
    // 프라이머리키용 UID
    @objc dynamic var uid: Int = 0
    
    // #### 개인정보 ####
    // 이름
    @objc dynamic var name: String = ""
    // 성
    @objc dynamic var surName: String = ""
    // 주소
    @objc dynamic var address: String = ""
    // 전화 번호
    @objc dynamic var phone: String = ""
    // 모바일
    @objc dynamic var mobile: String = ""
    // 메일주소
    @objc dynamic var email: String = ""
    
    // ### 직장정보 ###
    // 직장 주소
    @objc dynamic var workAddress: String = ""
    // 직장 전화 번호
    @objc dynamic var workPhone: String = ""
    // 직장 메일주소
    @objc dynamic var workEmail: String = ""

    // ### 좋아하는 정보 ###
    // 좋아하는 영화
    @objc dynamic var favouriteFilm: String = ""
    // 좋아하는 책
    @objc dynamic var favouriteBook: String = ""
    // 좋아하는 음악
    @objc dynamic var favouriteMusic: String = ""

    // 프라이머리키 설정
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    convenience init(uid: Int,
                     name: String,
                     surName: String,
                     address: String,
                     phone: String,
                     mobile: String,
                     email: String,
                     workAddress: String,
                     workPhone: String,
                     workEmail: String,
                     favouriteFilm: String,
                     favouriteBook: String,
                     favouriteMusic: String) {
        self.init()
        
        self.uid = uid
        self.name = name
        self.surName = surName
        self.phone = phone
        self.mobile = mobile
        self.email = email
        
        self.workAddress = workAddress
        self.workPhone = workPhone
        self.workPhone = workPhone
        
        self.favouriteFilm = favouriteFilm
        self.favouriteBook = favouriteBook
        self.favouriteMusic = favouriteMusic
    }
    
    // 클래스 복사
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = OwnerInfo(uid: uid,
                             name: name,
                             surName: surName,
                             address: address,
                             phone: phone,
                             mobile: mobile,
                             email: email,
                             workAddress: workAddress,
                             workPhone: workPhone,
                             workEmail: workEmail,
                             favouriteFilm: favouriteFilm,
                             favouriteBook: favouriteBook,
                             favouriteMusic: favouriteMusic)
        
        return copy
    }
    
    // 딕셔너리 값으로 필드값 세팅해주기
    convenience init(_ dicFields: [String: String]) {
        self.init()
        
        self.SQLParsing(dicFields)
    }
    
    // 필드 값 세팅
    func setField(field: String, value: String) {
        
        if field == "uid" {
            self.uid = Int(value) ?? 0
        }
        else if field == "name" {
            self.name = value
        }
        else if field == "surName" {
            self.surName = value
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
    }
    
    // SQL 파싱
    func SQLParsing(_ dicFields: [String: String]) {
        
        for key in dicFields.keys {
            // 필드 값 세팅
            self.setField(field: key, value: dicFields[key]!)
        }
    }
    
    // SQL 실행하다.
    @discardableResult  // <- Result of call to 'SQLExcute(sql:)' is unused
    // command : 명령어
    // condition : 조건식
    // dicFields : 필드명 + 필드값
    static func SQLExcute(command: String, condition: String?, dicFields: [String: String]?) -> Results<Object>? {
        
        if command == "INSERT" {
            let newPerson = OwnerInfo(dicFields!)
            
            // isPrimaryKey는 프라이머리키 설정 했는지 유무
            DBManager.sharedInstance.insertSQL(objs: newPerson, isPrimaryKey: true)
        }
        else if command == "UPDATE" {
            // 조건식 검색해서 존재할 경우
            let objects = DBManager.sharedInstance.selectSQL(type: OwnerInfo.self, condition: condition ?? "")?.first
            if objects != nil {
                let newPerson: OwnerInfo = objects?.copy() as! OwnerInfo
                
                // 변경된 내용 수정
                newPerson.SQLParsing(dicFields!)
                
                // isPrimaryKey는 프라이머리키 설정 했는지 유무
                DBManager.sharedInstance.updateSQL(objs: newPerson, isPrimaryKey: true)
            }
        }
        else if command == "DELETE" {
            // 조건식 검색해서 존재할 경우
            let objects = DBManager.sharedInstance.selectSQL(type: OwnerInfo.self, condition: condition ?? "")?.first
            if objects != nil {
                DBManager.sharedInstance.deleteSQL(objs: objects!)
            }
        }
        else if command == "SELECT" {
            // 검색 조건이 없을 경우 전체 검색
            if condition == nil {
                return DBManager.sharedInstance.selectSQL(type: OwnerInfo.self)
            }
                // 검색 조건이 있을 경우 조건 검색
            else {
                return DBManager.sharedInstance.selectSQL(type: OwnerInfo.self, condition: condition ?? "")
            }
        }
        
        return nil
    }
}
