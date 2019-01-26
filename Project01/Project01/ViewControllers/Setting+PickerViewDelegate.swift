//
//  Setting+PickerViewDelegate.swift
//  Project01ForZn
//
//  Created by 박종현 on 15/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension SettingViewController {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRow = 0
        if pickerViewArray == 0 {
            numberOfRow = self.fontArray.count
        }else if pickerViewArray == 1 {
            numberOfRow = self.fontSizeArray.count
        }else {
            
        }
        return numberOfRow
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerViewArray == 0 {
            
        }else if pickerViewArray == 1 {
            
        }else {
            
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String()
        if pickerViewArray == 0 {
            title = self.fontArray[row].toFontName()
        }else if pickerViewArray == 1 {
            title = String(self.fontSizeArray[row])
        }else {
            
        }
        return title
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfComponents = 1
        return numberOfComponents
    }
    
}
