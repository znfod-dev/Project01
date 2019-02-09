//
//  MonthPickerView.swift
//  Project01
//
//  Created by 박종현 on 09/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class MonthPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var monthBackView: UIView!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var yearPicker: UIPickerView!
    
    var monthArray = Array<Int>()
    var yearArray = Array<Int>()
    
    var date = Date()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init?(coder aDecoder: NSCoder)")
        for i in 1..<13 {
            monthArray.append(i)
        }
        for i in 2010..<2031 {
            yearArray.append(i)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init(frame: CGRect)")
        
    }
    
    static func initWithNib(frame:CGRect) -> MonthPickerView {
        let xibName = "MonthPickerView"
        let view:MonthPickerView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! MonthPickerView
        view.frame = frame
        view.isHidden = true
        
        view.monthPicker.tag = 0
        view.yearPicker.tag = 1
        DispatchQueue.main.async {
            view.monthBackView.frame.origin.y += view.monthBackView.frame.height
        }
        return view
        
        
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.dismissMonthPickerView()
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismissMonthPickerView()
    }
    
    func dismissMonthPickerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.monthBackView.frame.origin.y += self.monthBackView.frame.height
        }) { success in
            self.isHidden = true
        }
    }
    func showMonthPickerView(date:Date) {
        self.date = date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self.date)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: self.date)
        self.monthPicker.selectRow(Int(month)!-1, inComponent: 0, animated: true)
        self.yearPicker.selectRow(Int(year)!-2010, inComponent: 0, animated: true)
        
        self.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.monthBackView.frame.origin.y -= self.monthBackView.frame.height
        }) { success in
            
        }
    }
    
    // MARK: UIPickerDelegate + DataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRow = 0
        if pickerView.tag == 0 {
            //numberOfRow = self.fontArray.count
            numberOfRow = self.monthArray.count
        }else if pickerView.tag == 1 {
            //numberOfRow = self.fontSizeArray.count
            numberOfRow = self.yearArray.count
        }else {
            
        }
        return numberOfRow
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let calendar = Calendar.current
        var dateComponents: DateComponents? = calendar.dateComponents([.year, .month], from: self.date)
        if pickerView.tag == 0 {
            dateComponents?.month = self.monthArray[row]
            // 시작날 - 마지막날
            self.date = calendar.date(from: dateComponents!)!
        }else if pickerView.tag == 1 {
            dateComponents?.year = self.yearArray[row]
            // 시작날 - 마지막날
            self.date = Date().endOfMonth(date: calendar.date(from: dateComponents!)!)
        }else {
            
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String()
        if pickerView.tag == 0 {
            //title = self.fontArray[row].toFontName()
            title = String(self.monthArray[row])
        }else if pickerView.tag == 1 {
            //title = String(self.fontSizeArray[row])
            title = String(self.yearArray[row])
        }else {
            
        }
        return title
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfComponents = 1
        return numberOfComponents
    }
    
}
