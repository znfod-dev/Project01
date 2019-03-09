//
//  Profile2+TextField.swift
//  Project01
//
//  Created by 박종현 on 24/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import UIKit

extension Profile2ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == 0 {
            self.nameDelBtn.isHidden = false
        }else if tag == 1 {
            self.addressDelBtn.isHidden = false
        }else if tag == 2 {
            self.phoneDelBtn.isHidden = false
        }else if tag == 3 {
            self.emailDelBtn.isHidden = false
        }else {
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == 0 {
            self.profile.name = textField.text!
            self.nameDelBtn.isHidden = true
        }else if tag == 1 {
            self.profile.address = textField.text!
            self.addressDelBtn.isHidden = true
        }else if tag == 2 {
            self.profile.phone = textField.text!
            self.phoneDelBtn.isHidden = true
        }else if tag == 3 {
            self.profile.email = textField.text!
            self.emailDelBtn.isHidden = true
        }else {
            
        }
        DBManager.sharedInstance.updateProfile(profile: self.profile)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if tag == 0 {
            addressTextField.becomeFirstResponder()
        }else if tag == 1 {
            phoneTextField.becomeFirstResponder()
        }else if tag == 2 {
            emailTextField.becomeFirstResponder()
        }else if tag == 3 {
            textField.resignFirstResponder()
        }else {
            
        }
        
        return true
    }
}


