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
    var selectedDay: Date?
    
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
        if self.startDayClicked! { // 시작일 클릭 시
            self.selectedDay = date
            self.startDay = date.string()
        } else { // 종료일 클릭 시
            if self.startDay! > date.string() { // 시작일 보다 작다면
                self.okAlert("시작일보다 이전날짜는 선택할 수 없습니다.", nil)
            } else { // 시작일 보다 작지 않다면
                self.endDay = date.string()
            }
        }
    }
}
