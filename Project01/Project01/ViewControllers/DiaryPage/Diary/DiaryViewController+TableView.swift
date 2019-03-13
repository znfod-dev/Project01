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
        numberOfRow = 1
        
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DiaryTableCell!
        let section = indexPath.section
        let diary = self.diaryList[section]
        
        let month = Int(diary.id)!%10000/100
        let day = Int(diary.id)!%100
        let edited = self.diaryEditList[section]
        if edited == true {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryEditTableCell") as? DiaryTableCell
            cell.todoList = diary.todoList
            cell.todoTableView.reloadData()
            cell.diaryTextView.text = diary.diary
            cell.diaryTextView.tag = section
            cell.editBtn.tag = section
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell") as? DiaryTableCell
            cell.todoList = diary.todoList
            cell.todoTableView.reloadData()
            cell.diaryLabel.text = diary.diary
            cell.editBtn.tag = section
            
        }
        cell.todoViewHeight.constant = CGFloat(40 * diary.todoList.count)
        cell.dateLabel.text = "\(month)월 \(day)일"
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRow:CGFloat = 0
        heightForRow = UITableView.automaticDimension
        
        
        return heightForRow
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = self.diaryList.count;
        // Section = 1 DiaryCell
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete tapped")
            
            let section = indexPath.section
            let diary = self.diaryList[section]
            DBManager.shared.deleteDiary(diary: diary, completion: {
                print("delete complete")
                self.loadDiary()
            })
            
            success(true)
        })
        deleteAction.image = UIImage(named: "icon_cell_delete")
        deleteAction.backgroundColor = UIColor(hex: 0x929292)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.0
    }
}
