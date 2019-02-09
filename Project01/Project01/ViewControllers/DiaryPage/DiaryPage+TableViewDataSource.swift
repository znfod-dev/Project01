//
//  DiaryPage+TableViewDataSource.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryPageViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 3
        return numberOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        if section == 0 {
            //
            numberOfRow = 4
        }else if section == 1 {
            // todoList
            if self.diary.todoList.count == 0 {
                return 1
            }else {
                return self.diary.todoList.count
            }
        }else if section == 2 {
            
        }
        return numberOfRow
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DiaryPageTableCell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageTableNoneCell") as! DiaryPageTableCell
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageTableTitleCell") as! DiaryPageTableCell
            var title = String()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .weekday], from: currentDate)
            if row == 0 {
                let month = Month.init(rawValue: components.month!)
                title = month!.toString()
            }else if row == 1 {
                let year =  String(describing: components.year!)
                title = year
            }else if row == 2 {
                let weekday = WeekDay.init(rawValue: components.weekday!)
                title = weekday!.toString()
            }else if row == 3 {
                let day = String(describing:components.day!)
                title = day
                
            }
            
            cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
            
        }else if section == 1 {
            if self.diary.todoList.count == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageTableAddTodoCell") as! DiaryPageTableCell
                cell.todoLabel.attributedText = FontManager.shared.getTextWithFont(text: "할일 추가")
                
            }else {
                let row = indexPath.row
                let todo = self.diary.todoList[row]
                cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageTableTodoCell") as! DiaryPageTableCell
                cell.todoLabel.attributedText = FontManager.shared.getTextWithFont(text: todo.title!)
            }
            
            
        }else if section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageTableDiaryCell") as! DiaryPageTableCell
            if self.diary.diary == "" {
                self.diary.diary = " "
            }
            let diaryText = self.diary.diary
            cell.diaryTextView.attributedText = FontManager.shared.getTextWithFont(text: diaryText)
            
            cell.diaryTextView.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.diaryTextView.font = FontManager.shared.getTextFont()
            //for i in 0..<line {
            for i in 0..<100 {
                let y = i * Int(FontManager.shared.getLineHeight())
                let width = self.view.frame.width
                let backgroundView:UIView = UIView.init(frame: CGRect.init(x: 0, y: y, width: Int(width), height: Int(FontManager.shared.getLineHeight())))
                
                let line = UIView.init(frame: CGRect.init(x: 0, y: Int(FontManager.shared.getLineHeight())-1, width: Int(width), height: 1))
                line.backgroundColor = UIColor.black
                backgroundView.addSubview(line)
                backgroundView.backgroundColor = UIColor.clear
                backgroundView.isUserInteractionEnabled = false
                cell.addSubview(backgroundView)
            }
        }
        return cell
    }
}
