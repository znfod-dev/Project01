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
        var heightForRow:CGFloat = FontManager.shared.getLineHeight()
        let section = indexPath.section
        let row = indexPath.row
        
        if section == Profile.name.section() {
            
        }else if section == Profile.surname.section() {
            
        }else if section == Profile.address.section() {
            if row > 0 {
                heightForRow = UITableView.automaticDimension
            }
        }else if section == Profile.workAddress.section() {
            if row > 0 {
                heightForRow = UITableView.automaticDimension
            }
        }else if section == Profile.favouriteFilm.section() {
            if row > 0 {
                heightForRow = UITableView.automaticDimension
            }
        }else if section == Profile.favouriteBook.section() {
            if row > 0 {
                heightForRow = UITableView.automaticDimension
            }
        }else if section == Profile.favouriteMusic.section() {
            if row > 0 {
                heightForRow = UITableView.automaticDimension
            }
        }else {
            
        }
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        if section == Profile.name.section() {
            nameTextField.becomeFirstResponder()
        }else if section == Profile.surname.section() {
            surnameTextField.becomeFirstResponder()
        }else if section == Profile.address.section() {
            addressTextView.becomeFirstResponder()
        }else if section == Profile.phone.section() {
            phoneTextField.becomeFirstResponder()
        }else if section == Profile.mobile.section() {
            mobileTextField.becomeFirstResponder()
        }else if section == Profile.email.section() {
            emailTextField.becomeFirstResponder()
        }else if section == Profile.workAddress.section() {
            workaddressTextView.becomeFirstResponder()
        }else if section == Profile.workPhone.section() {
            workphoneTextField.becomeFirstResponder()
        }else if section == Profile.workEmail.section() {
            workemailTextField.becomeFirstResponder()
        }else if section == Profile.favouriteFilm.section() {
            favouritefilmTextView.becomeFirstResponder()
        }else if section == Profile.favouriteBook.section() {
            favouritebookTextView.becomeFirstResponder()
        }else if section == Profile.favouriteMusic.section() {
            favouritemusicTextView.becomeFirstResponder()
        }
        
    }
}
