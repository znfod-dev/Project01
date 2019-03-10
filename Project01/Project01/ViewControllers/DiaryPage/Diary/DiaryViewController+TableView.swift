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
        var cell:DiaryTableCell!
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let diary = self.diaryList[row]
            let month = Int(diary.id)!%10000/100
            let day = Int(diary.id)!%100
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell") as? DiaryTableCell
            cell.todoViewHeight.constant = 90
            cell.dateLabel.text = "\(month)월 \(day)일"
            cell.diaryLabel.text = diary.diary
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
