//
//  DiaryPageViewController.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryPageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var currentDate = Date()
    var diary = ModelDiary()
    var minimumDate = DBManager.sharedInstance.loadMinimumDateFromUD()
    var maximumDate = DBManager.sharedInstance.loadMaximumDateFromUD()
    
    var activeView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.setTableSetting()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.loadDiary()
    }
    
    func setTableSetting() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = FontManager.shared.getLineHeight()
    }
    
    // MARK:- UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: 200))
        let estimatedHeight = newSize.height > FontManager.shared.getLineHeight() ? newSize.height : FontManager.shared.getLineHeight()
        
        textView.frame = CGRect.init(x: 5, y: 0, width: textView.frame.width, height: estimatedHeight)
        
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        activeView = textView
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        self.diary.diary = textView.text
        if self.diary.diary == "" {
            self.diary.diary = " "
        }
        DBManager.sharedInstance.updateDiary(diary: self.diary)
        self.tableView.reloadData()
    }
    
    // MARK:- Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: kbSize.height, right: 0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            var aRect:CGRect = self.view.frame
            aRect.size.height -= kbSize.height
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK:- Actions
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Handle Swipe
    override func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("handleSwipeLeftGesture")
        
        if self.checkMaximumDate() {
            self.currentDate = Calendar.current.date(byAdding: .day, value: +1, to: self.currentDate)!
            self.loadDiary()
        } else {
            self.showAlert(title: "Warning", message: "마지막 페이지입니다.", submitTitle: "확인", submitHandler: { submit in
                
            }, cancelTitle: "취소", cancelHandler: { cancel in
                
            })
        }
        
    }
    override func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("handleSwipeRightGesture")
        if self.checkMinimumDate() {
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)!
            self.loadDiary()
        } else {
            self.showAlert(title: "Warning", message: "첫 페이지입니다.", submitTitle: "확인", submitHandler: { submit in
                
            }, cancelTitle: "취소", cancelHandler: { cancel in
                
            })
        }
        
    }
    // 최소 날짜 검사
    func checkMinimumDate() -> Bool {
        let updatePage = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.minimumDate)
        if Double(temp) < 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    // 최대 날짜 검사
    func checkMaximumDate() -> Bool {
        
        let updatePage = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.maximumDate)
        if Double(temp) > 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    
    // 다이어리 가져오기
    func loadDiary() {
        print("currentDate : \(currentDate)")
        self.diary = DBManager.sharedInstance.selectDiary(date: currentDate)
        print("self.diary : \(self.diary.todoList)")
        self.tableView.reloadData()
    }
    
    
}
