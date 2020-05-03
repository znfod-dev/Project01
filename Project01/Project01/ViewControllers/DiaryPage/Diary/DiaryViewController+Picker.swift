//
//  DiaryViewController+Picker.swift
//  Project01
//
//  Created by 박종현 on 10/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfComponents = 1
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = String(self.yearList[row])
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedYear = self.yearList[row]
        DispatchQueue.main.async {
            self.yearLabel.text = String("\(self.selectedYear) 년")
        }
    }
}
