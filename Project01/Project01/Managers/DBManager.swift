//
//  DBManager.swift
//  PlannerDiary
//
//  Created by 김삼현 on 15/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

/** 샘플 코드
 * INSERT, INTO, VALUES, UPDATE, SET, WHERE, DELETE, FROM, SELECT 등의 명령어는 대소문자 가리지 않습니다.
 *
 * Insert문
 * "Insert Into Person (id, firstName, lastName, gender, age) Values ('1', '홍', '길동', '0', '32');"
 *
 * Update문
 * "Update Person Set firstName='홍', lastName='길순', age='37' Where id='1';"
 *
 * Delete문 조건 삭제
 * "Delete From Person Where id='2';"
 *
 * Select문 전체 검색
 * "Select * From Person;"
 * Select문 조건 검색
 * "Select * From Person Where id='2';"
 */

import UIKit
import RealmSwift

class DBManager: NSObject {
    
    static let shared = DBManager()
    
    var database: Realm!
    
    override init() {
        super.init()
        print("DBManager init")
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 14,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 14 {
                    print("oldSchemaVersion")
                    // Apply any necessary migration logic here.
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        database = try! Realm()
    }
    
    // MARK: - Direct SQL Processing
    // INSERT문
    func insertSQL(objs: Object, isPrimaryKey: Bool = false) {
        try? database!.write ({
            if isPrimaryKey == true {
                // 프라이머리키 설정되어 있을때...
                database.add(objs, update: .modified)
            }
            else {
                database?.add(objs)
            }
        })
    }
    
    // UPDATE문
    func updateSQL(objs: Object, isPrimaryKey: Bool = false) {
        try? database!.write ({
            if isPrimaryKey == true {
                // 프라이머리키 설정되어 있을때...
                database.add(objs, update: .modified)
            }
            else {
                database?.add(objs)
            }
        })
    }
    
    // DELETE문
    func deleteDatabase() {
        try! database?.write({
            database?.deleteAll()
        })
    }
    
    // DELETE문
    func deleteSQL(objs : Object) {
        try? database!.write ({
            database?.delete(objs)
        })
    }
    
    // SELECT문
    func selectSQL(type: Object.Type) -> Results<Object>? {
        return database!.objects(type)
    }
    
    func selectSQL(type: Object.Type, condition: String) -> Results<Object>? {
        return self.database!.objects(type).filter(condition)
    }

    // MARK: - SQL Script Processing
    // SQL 실행하다.
    @discardableResult
    static func SQLExcute(sql: String) -> [String: Any] {
        
        // SQL 결과
        var RESULT_CODE = "0"
        var dicSQLResults:[String: Any] = [:]
        
        let sqlTemp = DBManager.commandUppercased(sql: sql)
        print("\n명령어=\(sqlTemp)")
        
        // SQL Parsing
        guard let dicTableData:[String: Any] = DBManager.SQLParsing(sql: sqlTemp) else {
            dicSQLResults["RESULT_CODE"] = "1"
            dicSQLResults["MESSAGE"] = "잘못된 SQL명령어 입니다."
            return dicSQLResults
        }
        
        // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
        let tableName: String = dicTableData["TABLE_NAME"] as! String
        if tableName == String(describing: ModelDBHoliday.self) {
            let result: (RESULT_CODE: String, RESULT_DATA: Results<Object>?) = ModelDBHoliday.SQLExcute(dicTableData: dicTableData)
            RESULT_CODE = result.RESULT_CODE
            
            if result.RESULT_DATA != nil {
                dicSQLResults["RESULT_DATA"] = result.RESULT_DATA
            }
        }
        else if tableName == String(describing: ModelDBTodo.self) {
            let result: (RESULT_CODE: String, RESULT_DATA: Results<Object>?) = ModelDBTodo.SQLExcute(dicTableData: dicTableData)
            RESULT_CODE = result.RESULT_CODE
            
            if result.RESULT_DATA != nil {
                dicSQLResults["RESULT_DATA"] = result.RESULT_DATA
            }
        }
        else if tableName == String(describing: ModelDBProfile.self) {
            let result: (RESULT_CODE: String, RESULT_DATA: Results<Object>?) = ModelDBProfile.SQLExcute(dicTableData: dicTableData)
            RESULT_CODE = result.RESULT_CODE
            
            if result.RESULT_DATA != nil {
                dicSQLResults["RESULT_DATA"] = result.RESULT_DATA
            }
        }
        else {
            RESULT_CODE = "3"
        }
        
        // 결과 코드 저장
        dicSQLResults["RESULT_CODE"] = RESULT_CODE
        if RESULT_CODE == "2" {
            dicSQLResults["MESSAGE"] = "검색 조건에 맞는 데이터가 존재하지 않습니다."
        }
        else if RESULT_CODE == "3" {
            dicSQLResults["MESSAGE"] = "해당 테이블이 존재하지 않습니다."
        }

        return dicSQLResults
    }
}


extension DBManager {
    // MARK: - SQL Script Parsing
    // 명령어 대문자로 변환
    static func commandUppercased(sql: String) -> String {
        var arrCommand = sql.components(separatedBy: " ")
        for i in 0..<arrCommand.count {
            let command = arrCommand[i].uppercased()
            switch command {
            case "INSERT",
                 "INTO",
                 "VALUES",
                 "UPDATE",
                 "SET",
                 "WHERE",
                 "DELETE",
                 "FROM",
                 "SELECT":
                arrCommand[i] = command
                break
            default:
                break
            }
            
            // INSERT INTO - VALUES
            var arrSubCommand = arrCommand[i].components(separatedBy: "(")
            if arrSubCommand.count == 2 {
                if arrSubCommand[0].uppercased() == "VALUES" {
                    arrSubCommand[0] = "VALUES"
                }
                
                arrCommand[i] = arrSubCommand.joined(separator:"(")
            }
        }
        
        let temp1 = arrCommand.joined(separator:" ")
        let temp2 = temp1.replacingOccurrences(of: " (", with: "(")
        
        return temp2
    }
    
    // SQL Parsing
	static func SQLParsing(sql: String) -> [String: Any]? {
		// 앞에 6글자만 잘라서 대문자로 변환
		let command = sql.prefix(6).uppercased()
		let sql = sql.replacingOccurrences(of: ";", with: "")
		let arrCommand = sql.components(separatedBy: " WHERE ")
		let strCommand: String = arrCommand.first!
		var strWhere: String = ""
		if arrCommand.count >= 2 {
			strWhere = arrCommand[1]
		}
		
		if command == "INSERT" {
			let temp1 = strCommand.mid(12)
			let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
			let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
			let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
			let arrSQL = temp4.components(separatedBy: " VALUES(")
			if arrSQL.count != 2 {
				print("INSERT 잘못된 명령어")
				return nil
			}
			
			let arrTable = arrSQL[0].components(separatedBy: "(")
			if arrTable.count != 2 {
				print("INSERT 잘못된 명령어")
				return nil
			}
			
			// 테이블 명령어 정리
			var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = arrTable[0]
			let arrField = arrTable[1].components(separatedBy: ",")
			let arrValues = arrSQL[1].components(separatedBy: ",")
			if arrField.count == 0 || arrField.count != arrValues.count {
				return nil
			}
			
			var dicFields:[String: String] = [:]
			for i in 0..<arrField.count {
				// 필드 값 세팅
				let field = arrField[i]
				let value = arrValues[i]
				dicFields[field] = value
			}
			
			dicTableData["FIELDS"] = dicFields
			
			return dicTableData
		}
		else if command == "UPDATE" {
			if strWhere == "" {
				print("UPDATE 잘못된 명령어")
				return nil
			}
			
			let temp1 = strCommand.mid(7)
			let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
			let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
			let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
			let arrSQL = temp4.components(separatedBy: " SET ")
			if arrSQL.count != 2 {
				print("INSERT 잘못된 명령어")
				return nil
			}
			
			// 테이블 명령어 정리
			var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = arrSQL[0]
			
			let arrDatas = arrSQL[1].components(separatedBy: ",")
			var dicFields:[String: String] = [:]
			for data in arrDatas {
				// 필드 값 세팅
				let arrItem = data.components(separatedBy: "=")
				let field = arrItem[0]
				let value = arrItem[1]
				dicFields[field] = value
			}
			
			dicTableData["FIELDS"] = dicFields
			dicTableData["WHERE"] = strWhere
			
			return dicTableData
		}
		else if command == "DELETE" {
			let temp1 = strCommand.mid(12)
			let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
			let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
			let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
			
			// 테이블 명령어 정리
			var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = temp4
			// WHERE
			if strWhere != "" {
				dicTableData["WHERE"] = strWhere
			}
			
			return dicTableData
		}
		else if command == "SELECT" {
			let temp1 = strCommand.mid(7)
			let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
			let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
			let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
			
			let arrSQL = temp4.components(separatedBy: " FROM ")
			// 테이블 명령어 정리
			var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["SELECT"] = arrSQL[0]
			
			dicTableData["TABLE_NAME"] = arrSQL[1]
			
			// WHERE
			if strWhere != "" {
				dicTableData["WHERE"] = strWhere
			}
			
			return dicTableData
		}
		else {
			return nil
		}
	}
}








