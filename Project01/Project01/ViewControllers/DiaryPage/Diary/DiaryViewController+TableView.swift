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
            numberOfRow = self.dayOfMonthList[selectedMonth];
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DiaryTableCell!
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
                //cell = tableView.dequeueReusableCell(withIdentifier: "DiaryEditTableCell") as? DiaryTableCell
              
                //cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell") as? DiaryTableCell
            let id = Date.GetId(year: selectedYear, month: selectedMonth, day: row+1)
            
            for diary in self.diaryArray {
                if diary.id == id {
                    let edit = self.editedArray[row]
                    if edit == true {
                        cell = tableView.dequeueReusableCell(withIdentifier: "DiaryEditTableCell") as? DiaryTableCell
                    }else {
                        cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell") as? DiaryTableCell
                        cell.editBtn.tag = row
                    }
                    cell.dateLabel.text = "\(self.selectedMonth)월 \(row+1)일"
                    return cell
                }
            }
            
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryAddTableCell") as? DiaryTableCell
            cell.createBtn.tag = row
            cell.dateLabel.text = "\(self.selectedMonth)월 \(row+1)일"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        var heightForRow:CGFloat = 0
        if section == 0 {
            let id = Date.GetId(year: selectedYear, month: selectedMonth, day: row+1)
            for diary in self.diaryArray {
                if diary.id == id {
                    let edit = self.editedArray[row]
                    if edit == true {
                        heightForRow = 250
                    }else {
                        heightForRow = 200
                    }
                    return heightForRow
                }
            }
            heightForRow = 70
        }
        return heightForRow
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        // Section = 1 DiaryCell
        return numberOfSection
    }
    
    
}
