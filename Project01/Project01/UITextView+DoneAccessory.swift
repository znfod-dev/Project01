//
//  UITextView+DoneAccessory.swift
//  Project01
//
//  Created by 박종현 on 01/01/2019.
//  Copyright © 2019 박종현. All rights reserved.
//

import Foundation
import UIKit
extension ZnTextView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    @IBInspectable var saveAccessory: Bool{
        get{
            return self.saveAccessory
        }
        set (hasSave) {
            if hasSave{
                addSaveButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func addSaveButtonOnKeyboard()
    {
        let saveToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        saveToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveButtonAction))
        
        let items = [flexSpace, done]
        saveToolbar.items = items
        saveToolbar.sizeToFit()
        
        self.inputAccessoryView = saveToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    @objc func saveButtonAction()
    {
        self.resignFirstResponder()
    }
}


