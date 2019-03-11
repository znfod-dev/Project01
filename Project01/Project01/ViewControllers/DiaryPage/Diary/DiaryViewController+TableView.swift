//
//  DiaryViewController+CollectionView.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if section == 0 {
            numberOfRow = self.diaryList.count;
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt : \(indexPath.row)")
        var cell:DiaryTableCell!
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let diary = self.diaryList[row]
            
            let month = Int(diary.id)!%10000/100
            let day = Int(diary.id)!%100
            let edited = self.diaryEditList[row]
            if edited == true {
                cell = tableView.dequeueReusableCell(withIdentifier: "DiaryEditTableCell") as? DiaryTableCell
                cell.todoList = diary.todoList
                cell.todoTableView.reloadData()
                cell.diaryTextView.text = diary.diary
                cell.diaryTextView.tag = row
                cell.editBtn.tag = row
            }else {
                cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell") as? DiaryTableCell
                cell.todoList = diary.todoList
                cell.todoTableView.reloadData()
                cell.diaryLabel.text = diary.diary
                cell.editBtn.tag = row
                
            }
            cell.todoViewHeight.constant = CGFloat(40 * diary.todoList.count)
            cell.dateLabel.text = "\(month)월 \(day)일"
            print("cellForRowAt DiaryTableCell : \(cell.frame)")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt : \(indexPath.row)")
        let section = indexPath.section
        let row = indexPath.row
        var heightForRow:CGFloat = 0
        if section == 0 {
            heightForRow = UITableView.automaticDimension
        }
        
        return heightForRow
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        // Section = 1 DiaryCell
        return numberOfSection
    }
    
    
}
