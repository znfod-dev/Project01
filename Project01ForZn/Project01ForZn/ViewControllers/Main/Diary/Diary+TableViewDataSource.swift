//
//  Diary+TableViewDataSource.swift
//  Project01ForZn
//
//  Created by 박종현 on 17/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 6
        // 0 = 년도
        // 1 = 요일
        // 2 = 월
        // 3 = 일
        // 4 = 계획리스트
        // 5 = 다이어리
        return numberOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if section == 0 {
            // 년도
            numberOfRow = 1
        }else if section == 1 {
            // 요일
            numberOfRow = 1
        }else if section == 2 {
            // 월
            numberOfRow = 1
        }else if section == 3 {
            // 일
            numberOfRow = 1
        }else if section == 4 {
            // 계획리스트
            numberOfRow = 1
        }else if section == 5 {
            // 다이어리
            numberOfRow = 24
        }else {
            
        }
        return numberOfRow
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell:UITableViewCell = UITableViewCell.init()
        
        if section == Diary.year.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryYearTableCell") as! DiaryTableCell
        }else if section == Diary.weekday.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryWeekdayTableCell") as! DiaryTableCell
        }else if section == Diary.month.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryMonthTableCell") as! DiaryTableCell
        }else if section == Diary.day.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryDayTableCell") as! DiaryTableCell
        }else if section == Diary.plan.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPlanTableCell") as! DiaryTableCell
        }else if section == Diary.content.section() {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryContentTableCell") as! DiaryTableCell
        }else {
            
        }
        
        return cell
    }
}
