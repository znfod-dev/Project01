//
//  SettingViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fontPickerView:PickerView!
    
    var fontArray = FontType.allCases
    var fontSizeArray = [10,12,14,16,18,20,22,24]
    var pickerViewArray = 0
    
    var datePickerView:DatePickerView!
    var timePickerView:TimePickerView!
    var fontSizePickerView:PickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePickerView = DatePickerView.initWithNib(frame: self.view.frame)
        let dateSubmit = UITapGestureRecognizer(target: self, action: #selector(handleDateSubmit(_:)))
        self.datePickerView.submitBtn.addGestureRecognizer(dateSubmit)
        self.view.addSubview(self.datePickerView)
        
        self.timePickerView = TimePickerView.initWithNib(frame: self.view.frame)
        let timeSubmit = UITapGestureRecognizer(target: self, action: #selector(handleTimeSubmit(_:)))
        self.timePickerView.submitBtn.addGestureRecognizer(timeSubmit)
        self.view.addSubview(self.timePickerView)
        
        
        self.fontPickerView = PickerView.initWithNib(frame: self.view.frame)
        self.fontPickerView.pickerView.delegate = self
        self.fontPickerView.pickerView.dataSource = self
        
        let fontSubmit = UITapGestureRecognizer(target: self, action: #selector(handleFontSubmit))
        self.fontPickerView.submitBtn.addGestureRecognizer(fontSubmit)
        self.view.addSubview(self.fontPickerView)
        
        self.fontSizePickerView = PickerView.initWithNib(frame: self.view.frame)
        self.fontSizePickerView.pickerView.delegate = self
        self.fontSizePickerView.pickerView.dataSource = self
        let fontSizeSubmit = UITapGestureRecognizer(target: self, action: #selector(handleFontSizeSubmit))
        self.fontSizePickerView.submitBtn.addGestureRecognizer(fontSizeSubmit)
        self.view.addSubview(self.fontSizePickerView)
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if section == 0 {
            numberOfRow = 3
        }else if section == 1 {
            numberOfRow = 2
        }else {
            
        }
        return numberOfRow
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForHeader = String()
        if section == 0 {
            titleForHeader = "Diary"
        }else if section == 1 {
            titleForHeader = "Font"
        }else {
            
        }
        return titleForHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingStartDateCell") as! SettingTableCell
        if section == 0 {
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingStartDateCell") as! SettingTableCell
                let startDate = DBManager.shared.loadMinimumDateFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "yyyy-MM-dd"
                let minimumDate = formatter.string(from: startDate)
                cell.startDateLabel.text = minimumDate
            }else if row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingLastDateCell") as! SettingTableCell
                let endDate = DBManager.shared.loadMaximumDateFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "yyyy-MM-dd"
                let maximumDate = formatter.string(from: endDate)
                cell.lastDateLabel.text = maximumDate
            }else if row == 2 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingAlarmCell") as! SettingTableCell
                let alarmTime = DBManager.shared.loadAlarmTimeFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "HH:mm"
                let time = formatter.string(from: alarmTime)
                cell.alarmLabel.text = time
            }else {
                
            }
        }else if section == 1 {
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingFontCell") as! SettingTableCell
            }else if row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingFontSizeCell") as! SettingTableCell
            }else {
                
            }
        }else {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        if section == 0 {
            if row == 0 {
                let startDate = DBManager.shared.loadMinimumDateFromUD()
                self.datePickerView.submitBtn.tag = 0
                self.showDatePickerView(date: startDate)
            }else if row == 1 {
                let endDate = DBManager.shared.loadMaximumDateFromUD()
                self.datePickerView.submitBtn.tag = 1
                self.showDatePickerView(date: endDate)
            }else if row == 2 {
                let alarmTime = DBManager.shared.loadAlarmTimeFromUD()
                self.timePickerView.submitBtn.tag = 0
                self.showTimePickerView(time: alarmTime)
            }else {
                
            }
        }else if section == 1 {
            if row == 0 {
                self.showFontPickerView()
            }else if row == 1 {
                self.showFontSizePickerView()
            }else {
                
            }
        }else {
            
        }
    }
    
    func showDatePickerView(date:Date) {
        
        self.datePickerView.showDatePickerView(date: date)
    }
    func showTimePickerView(time:Date) {
        self.timePickerView.showTimePickerView(time: time)
    }
    
    func showFontPickerView() {
        print("showFontPickerView")
        self.pickerViewArray = 0
        self.fontPickerView.showPickerView()
    }
    func showFontSizePickerView() {
        print("showFontSizePickerView")
        self.pickerViewArray = 1
        self.fontSizePickerView.showPickerView()
    }
    @objc func handleDateSubmit(_ recognizer : UITapGestureRecognizer) {
        let view = recognizer.view!
        let type = view.tag
        print("type : \(type)")
        // type == 0 시작일
        if type == 0 {
            let startDate = self.datePickerView.datePicker.date
            DBManager.shared.saveMinimumDateInUD(minimumDate: startDate)
        // type == 1 종료일
        }else if type == 1 {
            let endDate = self.datePickerView.datePicker.date
            DBManager.shared.saveMaximumDateInUD(maximumDate: endDate)
        }
        self.datePickerView.dismissDatePickerView()
        self.tableView.reloadData()
        
    }
    @objc func handleTimeSubmit(_ recognizer : UITapGestureRecognizer) {
        let view = recognizer.view!
        let type = view.tag
        if type == 0 {
            let alarmTime = self.timePickerView.timePicker.date
            DBManager.shared.saveAlarmTimeInUD(time: alarmTime)
        }
        
        self.timePickerView.dismissTimePickerView()
        self.tableView.reloadData()
    }
    
    
    @objc func handleFontSubmit() {
        print("handleFontSubmit")
        let temp = self.fontPickerView.pickerView.selectedRow(inComponent: 0)
        FontManager.shared.setFontType(fontType: fontArray[temp])
        self.fontPickerView.dismissPickerView()
    }
    
    @objc func handleFontSizeSubmit() {
        print("handleFontSizeSubmit")
        let temp = self.fontSizePickerView.pickerView.selectedRow(inComponent: 0)
        FontManager.shared.setFontSize(size: CGFloat.init(fontSizeArray[temp]))
        self.fontSizePickerView.dismissPickerView()
    }
    
    
    
}
