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
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == 0 {
            self.profile.name = textField.text!
        }else if tag == 1 {
            self.profile.address = textField.text!
        }else if tag == 2 {
            self.profile.phone = textField.text!
        }else if tag == 3 {
            self.profile.email = textField.text!
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


