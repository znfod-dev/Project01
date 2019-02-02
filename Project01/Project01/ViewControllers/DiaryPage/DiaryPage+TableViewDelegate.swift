//
//  DiaryPage+TableViewDelegate.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryPageViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRow:CGFloat = FontManager.shared.getLineHeight()
        let section = indexPath.section
        // let row = indexPath.row
        if section == 0 {
            
        }else if section == 1 {
            
        }else if section == 2 {
            heightForRow = UITableView.automaticDimension
        }else {
            
        }
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        if section == 1 {
            if self.diary.todoList.count == 0 {
                print("didSelectRowAt 할일 추가")
            }
        }
        
    }
}
