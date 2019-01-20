//
//  Profile+TableViewDelegate.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension ProfileViewController {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRow:CGFloat = 44
        let section = indexPath.section
        if section == Profile.name.section() {
            
        }else if section == Profile.surname.section() {
            
        }else if section == Profile.address.section() {
            heightForRow = UITableView.automaticDimension
        }else {
            
        }
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        if section == Profile.name.section() {
            
        }else if section == Profile.surname.section() {
            
        }else if section == Profile.address.section() {
            
        }else {
            
        }
        
        
    }
}
