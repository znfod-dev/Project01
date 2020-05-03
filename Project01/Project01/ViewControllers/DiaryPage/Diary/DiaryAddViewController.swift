//
//  DiaryAddViewController.swift
//  Project01
//
//  Created by 박종현 on 09/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryAddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    var selectedDate:Date!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isDatePickerShow = false
    
    var submitClick: (() -> Void)?
    
    var datePickerHideY:CGFloat = 0
    var datePickerShowY:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        // 최소 일
        let minDate = DBManager.shared.loadMinimumDateFromUD()
        // 최대 일
        let maxDate = DBManager.shared.loadMaximumDateFromUD()
        
        self.datePicker.maximumDate = maxDate
        self.datePicker.minimumDate = minDate
        
        
        if let temp = self.selectedDate {
            self.dateLabel.text = temp.dateToString()
        }else {
            self.dateLabel.text = "날짜 선택"
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.backView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        self.datePickerHideY = self.datePickerView.frame.origin.y
        self.datePickerShowY = self.datePickerView.frame.origin.y - self.datePickerView.frame.height
    }
    
    // MARK: - @IBAction
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("submitBtnClicked")
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
            self.dateErrorLabel.isHidden = false
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
        print("pickerSubmitBtnClicked")
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
            
            self.dismissDatePickerView()
        }
    }
    
    @IBAction func pickerCancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        print("pickerCancelBtnClicked")
        self.dismissDatePickerView()
        
    }
    
    // MARK: - DatePicker
    func dismissDatePickerView() {
        print("dismissDatePickerView")
        if self.isDatePickerShow == true {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.datePickerView.frame.origin.y = self.datePickerHideY
                }, completion: { success in
                    print("completion")
                    self.isDatePickerShow = false
                    self.view.isUserInteractionEnabled = true
                })
            }
        }
    }
    func showDatePickerView() {
        print("showDatePickerView")
        if self.isDatePickerShow == false {
            self.datePicker.date = Date()
            self.view.isUserInteractionEnabled = false
            self.isDatePickerShow = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.datePickerView.frame.origin.y = self.datePickerShowY
                }, completion: { success in
                    print("completion")
                    self.view.isUserInteractionEnabled = true
                })
                
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        // textView를 열면 DatePicker를 닫아준다.
        dismissDatePickerView()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        let size = self.diaryTextView.bounds.size
        let newSize = self.diaryTextView.sizeThatFits(CGSize(width: size.width, height: 150))
        let estimatedHeight = newSize.height > 16 ? newSize.height : 16
        print("estimatedHeight : \(estimatedHeight)")
        
        let height = self.diaryTextView.frame.height
        if height > 150 {
            if estimatedHeight < 150 {
                self.diaryTextView.isScrollEnabled = false
            }else {
                self.diaryTextView.isScrollEnabled = true
            }
        }else {
            self.diaryTextView.isScrollEnabled = false
        }
    }
    @objc func dismissKeyboard() {
        print("dismissKeyboard")
        self.view.endEditing(true)
        
    }
    
}
