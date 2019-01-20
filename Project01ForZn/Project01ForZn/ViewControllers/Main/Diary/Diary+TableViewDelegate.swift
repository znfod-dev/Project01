//
//  Diary+TableViewDelegate.swift
//  Project01ForZn
//
//  Created by 박종현 on 17/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import UIKit

extension DiaryViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRow:CGFloat = 44
        let section = indexPath.section
        /*
        if section == ProfileTableNo.name.section() {
            
        }else if section == ProfileTableNo.surname.section() {
            
        }else if section == ProfileTableNo.address.section() {
            heightForRow = UITableView.automaticDimension
        }else {
            
        }
         */
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        if section == ProfileTableNo.name.section() {
            
        }else if section == ProfileTableNo.surname.section() {
            
        }else if section == ProfileTableNo.address.section() {
            
        }else {
            
        }
        */
        
    }
}
