//
//  AddPlan_ViewController.swift
//  Project01
//
//  Created by Byunsangjin on 12/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class AddPlan_ViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var alertView: UIView!
    
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    @IBOutlet var startDateConstraint: NSLayoutConstraint!
    @IBOutlet var endDateConstraint: NSLayoutConstraint!
    @IBOutlet var alertBottomConstraint: NSLayoutConstraint! // 알림 하단 Constraint
    
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    
    @IBOutlet var planTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    
    
    
    // MARK:- Variables
    var plan: ModelPlan?
    var isModify = false
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
    }
    
    
    
    func setUI() {
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.planTextField.becomeFirstResponder()
        self.planTextField.delegate = self
        self.memoTextView.delegate = self
        
        // Keyboard Observer 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // TapGesture추가
        self.startDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startDateClick)))
        self.endDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endDateClick)))
        
        // datePicker의 값이 변할때 label값 변경
        self.startDatePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
        self.endDatePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
        
        // 초기 날짜 세팅, 수정이면 기존 계획 날짜 그렇지 않으면 오늘
        self.startDateLabel.text = self.plan?.startDay ?? Date().string()
        self.endDateLabel.text = self.plan?.endDay ?? Date().string()
        
        // 계획 타이틀, 메모 세팅
        self.planTextField.text = self.plan?.planTitle ?? ""
        self.memoTextView.text = self.plan?.planMemo ?? ""
    }
    
    
    
    // startDatePicker 숨기기
    func startDatePickerHide() {
        self.startDateLabel.tag = 0
        self.startDatePicker.isHidden = true
        self.startDateConstraint.constant = 10
    }
    
    
    
    // endDatePicker 숨기기
    func endDatePickerHide() {
        self.endDateLabel.tag = 0
        self.endDatePicker.isHidden = true
        self.endDateConstraint.constant = 10
    }
    
    
    
    func dismissAlert() { // 알림 종료
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    
    // 예외처리 시 알림 띄우기
    func presentOkAlert(message: String) {
        let alertVC = self.storyboard?.instantiateViewController(withIdentifier: "OkAlertViewController") as! OkAlertViewController
        
        self.parent?.addChild(alertVC)
        self.parent?.view.addSubview(alertVC.view)
        alertVC.setTitle(message: message)
    }
    

    
    // datePicker값이 변할 떄
    @objc func changeDate(_ datePicker: UIDatePicker) {
        if datePicker.tag == 0 { // startDatePicker일 경우
            self.startDateLabel.text = datePicker.date.string()
            
            self.endDatePicker.minimumDate = datePicker.date
        } else { // endDatePicker일 경우
            self.endDateLabel.text = datePicker.date.string()
        }
    }
    
    
    
    // 키보드 나옴
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.alertBottomConstraint.constant = keyboardHeight - 150
        }
    }
    
    
    
    // 키보드 숨김
    @objc func keyboardWillHide(_ notification: Notification) {
        
    }
    
    
    
    // startDate를 클릭했을 때
    @objc func startDateClick() {
        self.alertView.endEditing(true)
        
        
        if self.startDateLabel.tag == 0 { // 피커가 숨겨져 있을 때
            self.alertView.frame.size.height = 550
            
            self.startDateLabel.tag = 1
            self.startDatePicker.isHidden = false
            self.startDateConstraint.constant = 170
            
            endDatePickerHide()
        } else { // 피커가 나와있을 떄
            self.alertView.frame.size.height = 400
            
            self.startDatePickerHide()
        }
    }
    
    
    
    // endDate를 클릭했을 때
    @objc func endDateClick() {
        self.alertView.endEditing(true)
        
        if self.endDateLabel.tag == 0 { // 피커가 숨겨져 있을 때
            self.alertView.frame.size.height = 550
            
            self.endDateLabel.tag = 1
            self.endDatePicker.isHidden = false
            self.endDateConstraint.constant = 170
            
            self.startDatePickerHide()
        } else { // 피커가 나와있을 떄
            self.alertView.frame.size.height = 400
            
            self.endDatePickerHide()
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func okButtonClick(_ sender: Any) {
        // 예외 상황 체크
        guard !((self.planTextField.text?.isEmpty)!) else { // 계획이 비어있다면
            let message = "계획을 입력해주세요."
            self.presentOkAlert(message: message)
            return
        }
        
        guard self.startDateLabel.text! <= self.endDateLabel.text! else { // 시작일이 더 크다면
            let message = "잘못된 일정입니다."
            self.presentOkAlert(message: message)
            return
        }
        
        let plan = ModelPlan()
        plan.planTitle = self.planTextField.text
        plan.planMemo = self.memoTextView.text
        plan.startDay = self.startDateLabel.text
        plan.endDay = self.endDateLabel.text
        

        let parent = self.parent as! PlannerViewController
        
        if isModify { // 수정할 떄
            let detailVC = self.children.first as! DetailPlan_ViewController
            
            detailVC.titleLabel.text = plan.planTitle
            detailVC.dateLabel.text = "\(plan.startDay!) ~ \(plan.endDay!)"
            detailVC.memoTextView.text = plan.planMemo
        } else { // 추가할 때
            DBManager.shared.addPlanDB(plan: plan)

            parent.planArray = DBManager.shared.selectPlanDB()
            parent.tableView.reloadData()
        }
        
        dismissAlert()
    }
    
    
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        dismissAlert()
    }
}



extension AddPlan_ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.startDatePickerHide()
        self.endDatePickerHide()
    }
}



extension AddPlan_ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.startDatePickerHide()
        self.endDatePickerHide()
    }
}
