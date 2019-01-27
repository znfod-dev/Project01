//
//  CalendarManager.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class CalendarManager {
	
	// 셀선택
	static var selectedCell: Int = -1
	
	// 월간 문자
	static func getMonthString(monthIndex:Int) -> String {
		if monthIndex < 1 || monthIndex > 12 {
			return ""
		}
		
		let arrMonthTitle: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		
		return arrMonthTitle[monthIndex-1]
	}
	
	// 월간 뒷배경 이미지
	static func getMonthImage(monthIndex:Int) -> UIImage? {
		if monthIndex < 1 || monthIndex > 12 {
			return nil
		}
		
		let arrMonthImage: [String] = ["bg_img_month-1.jpg", "bg_img_month-2.jpg", "bg_img_month-3.jpg", "bg_img_month-4.jpg", "bg_img_month-5.jpg", "bg_img_month-6.jpg", "bg_img_month-7.jpg", "bg_img_month-8.jpg", "bg_img_month-9.jpg", "bg_img_month-10.jpg", "bg_img_month-11.jpg", "bg_img_month-12.jpg"]

		return UIImage(named: arrMonthImage[monthIndex-1])
	}
	
	// 주간 긴문자
	static func getWeekFullString(weekIndex:Int) -> String {
		if weekIndex < 0 || weekIndex > 6 {
			return ""
		}
		
		let arrWeekTitle: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
		
		return arrWeekTitle[weekIndex]
	}
	
    // 오늘날짜 인덱스를 구해준다.
    static func getTodayIndex() -> Int {
        // 오늘날짜로 년월일을 구해준다.
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

		return (year * 10000 + month * 100 + day)
    }
    
    // 이번달 기준으로 value값을 가감 계산해준다.
    static func getYearMonth(amount:Int) -> (year:Int, month:Int) {
        // 오늘날짜로 년월일을 구해준다.
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        return getYearMonth(year: year, month: month, amount: amount)
    }
    
    // 선택한 년/월에서 계산해서 새로운 년/월을 반환해준다.
    static func getYearMonth(year:Int, month:Int, amount:Int) -> (year:Int, month:Int) {
        
        // 반복 횟수
        var loopCount = amount
        // 더할것인가?
        var isInc = true
        if loopCount < 0 {
            loopCount *= -1
            isInc = false
        }
        var newYear: Int = year
        var newMonth: Int = month
        
        for _ in 0..<loopCount {
            if isInc == true {
                newMonth += 1
            }
            else {
                newMonth -= 1
            }
            
            // 현재 월이 1월일 경우
            if newMonth < 1 {
                newYear -= 1
                newMonth = 12
            }
            
            // 현재 월이 12월일 경우
            if newMonth > 12 {
                newYear += 1
                newMonth = 1
            }
        }
        
        return (newYear, newMonth)
    }
	
	// 달력날짜 시작/종료일 세팅
    static func getYearMontLimite(startYYYYMMDD: Int, endYYYYMMDD: Int) -> [String: Any] {
		// 오늘 년/월 구하기
		let thisMonth: (year:Int, month:Int) = CalendarManager.getYearMonth(amount: 0)
		
		let sYYYYMMDD: String = "\(startYYYYMMDD)"
		let eYYYYMMDD: String = "\(endYYYYMMDD)"
		let startMonth: (year:Int, month:Int) = (Int(sYYYYMMDD.left(4))!, Int(sYYYYMMDD.mid(4, amount: 2))!)
		let endMonth: (year:Int, month:Int) = (Int(eYYYYMMDD.left(4))!, Int(eYYYYMMDD.mid(4, amount: 2))!)
		
		var curentMonth: (year:Int, month:Int) = startMonth
		var count: Int = 0
		var thisMonthCount: Int = -1
		
		var arrMonths = [(year:Int, month:Int)]()
        // 기본 3페이지 중간 페이지를 보여준다.
        var focusIndex: Int = 1
        // 반환해줄 목록
        var dicResult = [String: Any]()
        // 보여줄 년/월일 목록
		var arrResultMonths = [(year:Int, month:Int)]()
		
        repeat {
            curentMonth = CalendarManager.getYearMonth(year: startMonth.year, month: startMonth.month, amount: count)
            arrMonths += [curentMonth]
            if thisMonth == curentMonth {
                thisMonthCount = count
            }
            count += 1

        } while (endMonth.year == curentMonth.year && endMonth.month == curentMonth.month) == false

        // 이번달이 없을 경우...
		if thisMonthCount == -1 {
            for curentMonth in arrMonths {
                arrResultMonths += [curentMonth]
                if arrResultMonths.count == 3 {
                    break
                }
            }
		}
        else {
            // 이번달 한달전부터 시작
            var startIndex: Int = thisMonthCount - 1
            // 이번달이 목록의 마지막일 경우
            if thisMonthCount == (arrMonths.count - 1) {
                startIndex = thisMonthCount - 2
                focusIndex = 2
            }
            
            if startIndex < 0 {
                startIndex = 0
                focusIndex = 0
            }
            
            for i in startIndex..<arrMonths.count {
                let curentMonth = arrMonths[i]
                arrResultMonths += [curentMonth]
                if arrResultMonths.count == 3 {
                    break
                }
            }
        }
        
        // 기본 3페이지인데 적을 경우 포커스를 처음으로 이동시켜준다.
        if arrResultMonths.count < 3 {
            focusIndex = 0
        }
		
        dicResult["focusIndex"] = focusIndex
        dicResult["arrResultMonths"] = arrResultMonths
        
		return dicResult
	}
    
    // 년/월에 맞는 날짜 목록 얻어오기
    static func getMonthToDays(year:Int, month:Int) -> [[String: Any]] {
        
        // 선택한 달의 날짜 목록
        var arrCurentMoth:[[String: Any]] = []
        
        // 이번달
        let curYear: Int = year
        let curMonth: Int = month
        
        // 이전달
        var prevYear: Int = year
        var prevMonth: Int = curMonth - 1
        // 현재 월이 1월일 경우
        if prevMonth < 1 {
            prevMonth = 12
            prevYear = year - 1
        }
        
        // 다음달
        var nextYear: Int = year
        var nextMonth: Int = curMonth + 1
        // 현재 월이 12월일 경우
        if nextMonth > 12 {
            nextMonth = 1
            nextYear = year + 1
        }
        
        
        // 공휴일 정보 체크
        // 선택한 년/월 인덱스
        let curIndex = curYear * 100 + curMonth
        let prevIndex = prevYear * 100 + prevMonth
        let nextIndex = nextYear * 100 + nextMonth
        
        var dicHoliday:[String: String] = [:]
        
        // 공휴일 정보 검색
        var sql = "SELECT * FROM ModelDBHoliday WHERE dateYYYYMM=\(curIndex) OR dateYYYYMM=\(prevIndex) OR dateYYYYMM=\(nextIndex);"
        // SQL 결과
        var dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
        var resultCode: String = dicSQLResults["RESULT_CODE"] as! String
        // 검색 실패
        if resultCode == "0" {
            // 해당 년/월에 데이터가 저장되어 있으면...
            let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
            for i in 0..<resultData.count {
                let holiday: ModelDBHoliday = resultData[i] as! ModelDBHoliday
                dicHoliday["\(holiday.dateYYYYMMDD)"] = holiday.name
            }
        }
		
		// Todo List Count 구하기
		var dicTodoListCount:[String: Int] = [:]
		
		sql = "SELECT * FROM DBTodo WHERE date CONTAINS '\(curIndex)' OR date CONTAINS '\(prevIndex)' OR date CONTAINS '\(nextIndex)';"
		// SQL 결과
		dicSQLResults = DBManager.SQLExcute(sql: sql)
		resultCode = dicSQLResults["RESULT_CODE"] as! String
		// 검색 실패
		if resultCode == "0" {
			let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
			
			for i in 0..<resultData.count {
				let todo: DBTodo = resultData[i] as! DBTodo
				if dicTodoListCount.keys.contains(todo.date!) {
					
					var count: Int = dicTodoListCount[todo.date!]!
					count += 1
					dicTodoListCount[todo.date!] = count
				}
				else {
					dicTodoListCount[todo.date!] = 1
				}
			}
		}
        
        // 이전달 정보
        var comps = DateComponents()
        comps.year = prevYear
        comps.month = prevMonth
        comps.day = 1
        
        let calendar = Calendar.current
        var date: Date? = calendar.date(from: comps)
        
        var range: Range<Int>? = nil
        if let date = date {
            range = calendar.range(of: .day, in: .month, for: date)
        }
        // 이전달 날짜수
        let prevMothDayLength = range!.count
        
        // 이번달 정보
        comps.year = curYear
        comps.month = curMonth
        comps.day = 1
        
        date = calendar.date(from: comps)
        if let date = date {
            range = calendar.range(of: .day, in: .month, for: date)
        }
        // 이번달 날짜수
        let curMothDayLength = range!.count
        
        var comp: DateComponents? = nil
        if let date = date {
            comp = calendar.dateComponents([.weekday], from: date)
        }
        
        // 0:일, 1:월 ... 6:토
        let weekday: Int = comp!.weekday! - 1

        var dayCount = 0
        
        // 이전달
        var countDay: Int = prevMothDayLength - weekday
        for _ in 0..<weekday {
            countDay += 1
            
            let cellIndex = prevYear * 10000 + prevMonth * 100 + countDay
            var dicDayData = [String: Any]()
            dicDayData["year"] = prevYear
            dicDayData["month"] = prevMonth
            dicDayData["day"] = countDay
            dicDayData["cellIndex"] = cellIndex
            // 보여주는 월의 이전(-1), 현재(0), 다음달(1) 표시
            dicDayData["monthDirection"] = -1

            // 일요일 체크
            if (dayCount % 7) == 0 {
                dicDayData["isHoliday"] = true
            }
            else {
                dicDayData["isHoliday"] = false
            }
            
            // 공휴일 체크
            let holiday = dicHoliday["\(cellIndex)"]
            if CommonUtil.isEmpty(holiday as AnyObject) {
                dicDayData["holidayName"] = ""
            }
            else {
                dicDayData["isHoliday"] = true
                dicDayData["holidayName"] = holiday
            }
			
			// Todo List Count
			if dicTodoListCount.keys.contains("\(cellIndex)") {
				let count: Int = dicTodoListCount["\(cellIndex)"]!
				dicDayData["todoCount"] = count
			}
			else {
				dicDayData["todoCount"] = 0
			}

            arrCurentMoth.append(dicDayData)
            
            dayCount += 1
        }
        
        // 이번달
        countDay = 0
        for _ in 0..<curMothDayLength {
            countDay += 1

            let cellIndex = curYear * 10000 + curMonth * 100 + countDay
            var dicDayData = [String: Any]()
            dicDayData["year"] = curYear
            dicDayData["month"] = curMonth
            dicDayData["day"] = countDay
            dicDayData["cellIndex"] = cellIndex
            dicDayData["monthDirection"] = 0

            // 일요일 체크
            if (dayCount % 7) == 0 {
                dicDayData["isHoliday"] = true
            }
            else {
                dicDayData["isHoliday"] = false
            }
            
            // 공휴일 체크
            let holiday = dicHoliday["\(cellIndex)"]
            if CommonUtil.isEmpty(holiday as AnyObject) {
                dicDayData["holidayName"] = ""
            }
            else {
                dicDayData["isHoliday"] = true
                dicDayData["holidayName"] = holiday
            }

            // 음력 구하기
            let solar = Solar(year: curYear, month: curMonth, day: countDay)
            do {
                let lunar = try solar.toLunar()
                dicDayData["yearLunar"] = lunar.year
                dicDayData["monthLunar"] = lunar.month
                dicDayData["dayLunar"] = lunar.day

//                print("lunar year=\(lunar.year), month=\(lunar.month), day=\(lunar.day)")
            } catch let e {
                if e is CalendarLunar.ConvertError {
                    let error = e as! CalendarLunar.ConvertError
                    print(error.message)
                }
            }
			
			// Todo List Count
			if dicTodoListCount.keys.contains("\(cellIndex)") {
				let count: Int = dicTodoListCount["\(cellIndex)"]!
				dicDayData["todoCount"] = count
			}
			else {
				dicDayData["todoCount"] = 0
			}

            arrCurentMoth.append(dicDayData)
                        
            dayCount += 1
        }

        // 다음달
        let mod: Int = arrCurentMoth.count % 7
        if mod > 0 {
            let gep: Int = 7 - (arrCurentMoth.count % 7)
            countDay = 0
            for _ in 0..<gep {
                countDay += 1

                let cellIndex = nextYear * 10000 + nextMonth * 100 + countDay
                var dicDayData = [String: Any]()
                dicDayData["year"] = nextYear
                dicDayData["month"] = nextMonth
                dicDayData["day"] = countDay
                dicDayData["cellIndex"] = cellIndex
                dicDayData["monthDirection"] = 1
                dicDayData["isHoliday"] = false
                dicDayData["holidayName"] = ""
                
                // 공휴일 체크
                let holiday = dicHoliday["\(cellIndex)"]
                if CommonUtil.isEmpty(holiday as AnyObject) {
                    dicDayData["holidayName"] = ""
                }
                else {
                    dicDayData["isHoliday"] = true
                    dicDayData["holidayName"] = holiday
                }
				
				// Todo List Count
				if dicTodoListCount.keys.contains("\(cellIndex)") {
					let count: Int = dicTodoListCount["\(cellIndex)"]!
					dicDayData["todoCount"] = count
				}
				else {
					dicDayData["todoCount"] = 0
				}
				
                arrCurentMoth.append(dicDayData)
            }
        }

        return arrCurentMoth
    }
}
