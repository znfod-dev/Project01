//
//  SettingViewController.swift
//  Project01
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var backBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var fontPickerView:PickerView!
    
    var fontArray = FontType.allCases
    var fontSizeArray = [14,16,18]
    var pickerViewArray = 0
    
    var datePickerView:DatePickerView!
    var monthPickerView:MonthPickerView!
    var timePickerView:TimePickerView!
    var fontSizePickerView:PickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingViewController viewDidLoad")
        self.addPickerViews()
        // sama73 : 네비게이션 숨기기
        self.navigationController?.navigationBar.isHidden = true
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    // PickerView 추가
    func addPickerViews() {
        /*
        self.datePickerView = DatePickerView.initWithNib(frame: self.view.frame)
        let dateSubmit = UITapGestureRecognizer(target: self, action: #selector(handleDateSubmit(_:)))
        self.datePickerView.submitBtn.addGestureRecognizer(dateSubmit)
        self.view.addSubview(self.datePickerView)
        */
        self.monthPickerView = MonthPickerView.initWithNib(frame: self.view.frame)
        let monthSubmit = UITapGestureRecognizer(target: self, action: #selector(handleMonthSubmit(_:)))
        self.monthPickerView.submitBtn.addGestureRecognizer(monthSubmit)
      
        self.view.addSubview(self.monthPickerView)
        
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
    }
    
    // MARK: - UIButton Action
    // 사이드 메뉴
    @IBAction func onMenuClick(_ sender: Any) {
        print("onMenuClick")
        sideMenuController?.revealMenu()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // Diary
        // OpenSource
        //
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if section == 0 {
            numberOfRow = 5
        }else if section == 1 {
            /*
            numberOfRow = 2
        }else if section == 2 {
            numberOfRow = 1
        }else if section == 3 {
             */
            numberOfRow = 1
        }else {
            
        }
        return numberOfRow
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForHeader = String()
        if section == 0 {
            titleForHeader = "Diary"
        }else if section == 1 {
            /*
            titleForHeader = "Font"
        }else if section == 2 {
            titleForHeader = "Profile"
        }else if section == 3 {
             */
            titleForHeader = "OpenSource"
        }else {
            
        }
        return titleForHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRow:CGFloat = 44.0
        let fontSize = FontManager.shared.getFontSize()
        if fontSize == 14 {
            heightForRow = 36
        }else if fontSize == 16 {
            heightForRow = 38
        }else if fontSize == 18 {
            heightForRow = 40
        }else if fontSize == 20 {
            heightForRow = 42
        }else if fontSize == 22 {
            heightForRow = 44
        }else {
            
        }
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingNoneCell") as! SettingTableCell
        if section == 0 {
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingStartDateCell") as! SettingTableCell
                let startDate = DBManager.shared.loadMinimumDateFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "yyyy-MM"
                let minimumDate = formatter.string(from: startDate)
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                cell.startDateLabel.attributedText = FontManager.shared.getTextWithFont(text: minimumDate)
            }else if row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingLastDateCell") as! SettingTableCell
                let endDate = DBManager.shared.loadMaximumDateFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "yyyy-MM"
                let maximumDate = formatter.string(from: endDate)
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                cell.lastDateLabel.attributedText = FontManager.shared.getTextWithFont(text: maximumDate)
            }else if row == 2 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingAlarmCell") as! SettingTableCell
                let alarmTime = DBManager.shared.loadAlarmTimeFromUD()
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.dateFormat = "HH:mm"
                let time = formatter.string(from: alarmTime)
                //cell.alarmLabel.text = time
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                cell.alarmLabel.attributedText = FontManager.shared.getTextWithFont(text: time)
            }else if row == 3 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingLunarCell") as! SettingTableCell
                let lunarOnOff = DBManager.shared.loadLunarCalendarFromUD()
                
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                cell.lunarSwitch.isOn = lunarOnOff
            }else if row == 4 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingiCloudCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
            
            }else if row == 5 {
                print("SettingPagingCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingPagingCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                
                let pagingNumber = DBManager.shared.loadPagingNumberFromUD()
               
                if pagingNumber == 1 {
                    cell.pagingBtn.titleLabel?.text = "페이징1"
                    cell.pagingBtn.tag = 1
                    
                }else if pagingNumber == 2 {
                    cell.pagingBtn.titleLabel?.text = "페이징2"
                    cell.pagingBtn.tag = 2
                    
                }else if pagingNumber == 3 {
                    cell.pagingBtn.titleLabel?.text = "페이징3"
                    cell.pagingBtn.tag = 3
                    
                }else {
                    cell.pagingBtn.titleLabel?.text = "페이징1"
                    cell.pagingBtn.tag = 1
                    
                    DBManager.shared.savePagingNumberInUD(value: 1)
                }
            }else {
                
            }
        }else if section == 1 {
            /*
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingFontCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                let fontName = FontManager.shared.getTextFont().fontName
                
                cell.fontLabel.attributedText = FontManager.shared.getTextWithFont(text: fontName)
            }else if row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingFontSizeCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
                let fontSize = String("\(FontManager.shared.getTextFont().pointSize)")
                cell.fontSizeLabel.attributedText = FontManager.shared.getTextWithFont(text: fontSize)
            }else {
                
            }
        }else if section == 2 {
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingProfileCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
            }else {
                
            }
        }else if section == 3 {
             */
            if row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SettingOpenSourceCell") as! SettingTableCell
                cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: cell.titleLabel.text!)
            }else {
                
            }
        }else {
            
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        if section == 0 {
            if row == 0 {
                let startDate = DBManager.shared.loadMinimumDateFromUD()
                self.monthPickerView.submitBtn.tag = 0
                self.monthPickerView.tag = 0
                self.showMonthPickerView(date: startDate)
            }else if row == 1 {
                let endDate = DBManager.shared.loadMaximumDateFromUD()
                self.monthPickerView.submitBtn.tag = 1
                self.monthPickerView.tag = 1
                self.showMonthPickerView(date: endDate)
            }else if row == 2 {
                let alarmTime = DBManager.shared.loadAlarmTimeFromUD()
                self.timePickerView.submitBtn.tag = 0
                self.showTimePickerView(time: alarmTime)
            }else {
                
            }
        }else if section == 1 {
            /*
            if row == 0 {
                self.showFontPickerView()
            }else if row == 1 {
                self.showFontSizePickerView()
            }else {
                
            }
        }else if section == 2 {
            if row == 0 {
                self.showProfileView()
            }else {
                
            }
        }else if section == 3 {
             */
            if row == 0 {
                self.showOpenSourceView()
            }else {
                
            }
        }else {
            
        }
    }
    
    // MARK: - Show Hide Picker
    func showDatePickerView(date:Date) {
        
        self.datePickerView.showDatePickerView(date: date)
    }
    func showMonthPickerView(date:Date) {
        
        self.monthPickerView.showMonthPickerView(date: date)
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
    func showProfileView() {
        let storyboard:UIStoryboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        // sama73 : 네비게이션바를 이용해서 이동
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    // 오픈소스 라이브러리
    func showOpenSourceView() {
        let storyboard:UIStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        let opensourceVC: OpenSourceViewController = storyboard.instantiateViewController(withIdentifier: "OpenSource") as! OpenSourceViewController
        self.navigationController?.pushViewController(opensourceVC, animated: true)
        
    }
    
    // MARK: - HandleDate
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
    @objc func handleMonthSubmit(_ recognizer : UITapGestureRecognizer) {
        let view = recognizer.view!
        let type = view.tag
        print("type : \(type)")
        // type == 0 시작일
        if type == 0 {
            print("\(self.monthPickerView.date)")
            let startDate = self.monthPickerView.date
            // 시작날 - 마지막날
            let endDate = DBManager.shared.loadMaximumDateFromUD()
            if startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
                DBManager.shared.saveMinimumDateInUD(minimumDate: startDate)
				
				// 셀선택
				CalendarManager.setSelectedCell(selectedCell: -1)
            }else {
                self.okAlert("Warning", "시작날짜를 마지막날짜보다 늦게 설정할 수 없습니다.")
            }
            // type == 1 종료일
        }else if type == 1 {
            print("\(self.monthPickerView.date)")
            let endDate = self.monthPickerView.date
            // 시작날 - 마지막날
            let startDate = DBManager.shared.loadMinimumDateFromUD()
            if startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
                DBManager.shared.saveMaximumDateInUD(maximumDate: endDate)
				
				// 셀선택
				CalendarManager.setSelectedCell(selectedCell: -1)
            }else {
                self.okAlert("Warning", "마지막날짜를 시작날짜보다 일찍 설정할 수 없습니다.")
            }
        }
        self.monthPickerView.dismissMonthPickerView()
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
        self.tableView.reloadData()
    }
    
    @objc func handleFontSizeSubmit() {
        print("handleFontSizeSubmit")
        let temp = self.fontSizePickerView.pickerView.selectedRow(inComponent: 0)
        FontManager.shared.setFontSize(size: CGFloat.init(fontSizeArray[temp]))
        self.fontSizePickerView.dismissPickerView()
        self.tableView.reloadData()
    }
    
    @IBAction func pagingBtnClicked(_ sender: Any) {
        print("pagingBtnClicked")
        let tag = (sender as! UIButton).tag
        print("tag : \(tag)")
        if tag == 1 {
            DBManager.shared.savePagingNumberInUD(value: 2)
        }else if tag == 2 {
            DBManager.shared.savePagingNumberInUD(value: 3)
        }else if tag == 3 {
            DBManager.shared.savePagingNumberInUD(value: 1)
        }
        self.tableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .automatic)
    }
    
    @IBAction func lunarValueChanged(_ sender: Any) {
        let lunaSwitch:UISwitch = sender as! UISwitch
        let lunarOnoff = lunaSwitch.isOn
        DBManager.shared.saveLunarCalendarInUD(value: lunarOnoff)
    }
    
}
