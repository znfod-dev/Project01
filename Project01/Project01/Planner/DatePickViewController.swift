//
//  DatePickViewController.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import FSCalendar
import PopupDialog

class DatePickViewController: UIViewController {
    // MARK:- Variables
    var selectedDay: Date? = Date()
    
    var startDay: String?
    var endDay: String?
    
    var startDayClicked: Bool?
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



extension DatePickViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = date.string()
        
        guard self.startDayClicked != nil else {
            self.selectedDay = date
            return
        }
        
        // 직접입력 적용 시
        if self.startDayClicked! { // 시작일 설정할 때
            self.startDay = selectedDate
            if self.startDay! > self.endDay! { // 종료일이 시작일보다 앞이라면 날짜를 같게 한다.
                print("종료일이 시작일 보다 앞이다")
                self.endDay = self.startDay
            }
        } else { // 종료일 설정할 때
            if self.startDay! > selectedDate { // 시작일 보다 작다면
                self.okAlert("시작일보다 이전날짜는 선택할 수 없습니다.", nil)
            } else { // 시작일 보다 작지 않다면
                self.endDay = selectedDate
            }
        }
    }
}
