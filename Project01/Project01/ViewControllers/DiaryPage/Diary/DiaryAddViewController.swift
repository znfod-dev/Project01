//
//  DiaryAddViewController.swift
//  Project01
//
//  Created by 박종현 on 09/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryAddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    var selectedDate:Date!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var submitClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 최소 일
        let minDate = DBManager.shared.loadMinimumDateFromUD()
        // 최대 일
        let maxDate = DBManager.shared.loadMaximumDateFromUD()
        
        self.datePicker.maximumDate = maxDate
        self.datePicker.minimumDate = minDate
        self.datePickerView.isHidden = true
        
        
        if let temp = self.selectedDate {
            self.dateLabel.text = temp.dateToString()
        }else {
            self.dateLabel.text = "날짜 선택"
        }
        
    }

    // MARK: - @IBAction
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        
        if let _ = self.selectedDate {
            let id = self.selectedDate.GetId()
            let exist = DBManager.shared.selectDiary(id: id)
            if exist == true {
                
            }else {
                let date = self.selectedDate
                let diaryText = self.diaryTextView.text
                
                
                let diary = ModelDiary.init(id: id, date: date!, diary: diaryText!)
                
                DBManager.shared.insertDiary(diary: diary)
            }
            if self.submitClick != nil {
                self.submitClick!()
            }
            self.dismiss(animated: false, completion: nil)
        }else {
            showDatePickerView()
        }
        
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dateChooseBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        showDatePickerView()
    }
    
    @IBAction func pickerSubmitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        let id = datePicker.date.GetId()
        let exist = DBManager.shared.selectDiary(id: id)
        if exist == true {
            self.dateErrorLabel.isHidden = false
        }else {
            self.dateErrorLabel.isHidden = true
            
            let date = self.datePicker.date
            let dateString = date.dateToString()
            self.dateLabel.text = dateString
            self.selectedDate = date
            
            dismissDatePickerView()
         }
    }
    
    @IBAction func pickerCancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        dismissDatePickerView()
        
    }
    
    // MARK: - DatePicker
    func dismissDatePickerView() {
        print("dismissDatePickerView")
        
        if self.datePickerView.isHidden == false {
        
            UIView.animate(withDuration: 0.5, animations: {
                self.datePickerView.frame.origin.y += self.datePickerView.frame.height
            }) { success in
                self.datePickerView.isHidden = true
                
            }
        }
    }
    func showDatePickerView() {
        print("showDatePickerView")
        self.datePicker.date = Date()
        if self.datePickerView.isHidden == true {
         
            self.datePickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.datePickerView.frame.origin.y -= self.datePickerView.frame.height
            }) { success in
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        // textView를 열면 DatePicker를 닫아준다.
        dismissDatePickerView()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        let height = self.diaryTextView.frame.height
        if height > 150 {
            self.diaryTextView.isScrollEnabled = true
        }else {
            self.diaryTextView.isScrollEnabled = false
        }
    }
    
    
}
