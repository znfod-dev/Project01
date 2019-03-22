//
//  AddPlan_ViewController.swift
//  Project01
//
//  Created by Byunsangjin on 12/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class AddPlanViewController: UIViewController {
    
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
    
    //colorView
    @IBOutlet var oneView: UIView!
    @IBOutlet var twoView: UIView!
    @IBOutlet var threeView: UIView!
    @IBOutlet var fourView: UIView!
    @IBOutlet var fiveView: UIView!
    
    
    
    // MARK:- Variables
    var modiPlan: ModelPlan?
    var seletedColor: String = ViewColor.one.toString()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        
        self.planTextField.becomeFirstResponder()
        self.planTextField.delegate = self
        self.memoTextView.delegate = self
        
        self.colorViewSetGesture()
        
        self.alertView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    
    
    func setUI() {
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
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
        self.startDateLabel.text = self.modiPlan?.startDay ?? Date().string()
        self.endDateLabel.text = self.modiPlan?.endDay ?? Date().string()
        
        // 계획 타이틀, 메모 세팅
        self.planTextField.text = self.modiPlan?.planTitle ?? ""
        self.memoTextView.text = self.modiPlan?.planMemo ?? ""
        
        // 초기 colorView 선택
        self.oneView.layer.borderWidth = 3
        self.oneView.layer.borderColor = UIColor(hexString: "6A6A6A").cgColor
        
        
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
        
        alertVC.view.frame = (parent?.view.bounds)!
        
        self.parent?.addChild(alertVC)
        self.parent?.view.addSubview(alertVC.view)
        alertVC.setTitle(message: message)
    }
    

    
    // Border 초기화
    func initBorderWidth() {
        self.oneView.layer.borderWidth = 0
        self.twoView.layer.borderWidth = 0
        self.threeView.layer.borderWidth = 0
        self.fourView.layer.borderWidth = 0
        self.fiveView.layer.borderWidth = 0
    }
    
    
    
    // 색 선택 뷰 제스쳐 설정
    func colorViewSetGesture() {
        self.oneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectViewColor(tapGesture:))))
        self.twoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectViewColor(tapGesture:))))
        self.threeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectViewColor(tapGesture:))))
        self.fourView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectViewColor(tapGesture:))))
        self.fiveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectViewColor(tapGesture:))))
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
    
    
    
    @objc func selectViewColor(tapGesture: UITapGestureRecognizer) {
        let tag = tapGesture.view!.tag
        
        self.seletedColor = (ViewColor(rawValue: tag)?.toString())!
        
        self.initBorderWidth()
        
        // 선택한 뷰 보더 설정
        tapGesture.view?.layer.borderWidth = 3
        tapGesture.view?.layer.borderColor = UIColor(hexString: "6A6A6A").cgColor
    }
    
    
    
    // MARK:- Actions
    // 완료 버튼 눌렀을 시
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
        
        let parent = self.parent as! PlannerViewController
        
        if let modiPlan = self.modiPlan { // 수정할 때
            // 받아온 plan 바뀐값으로 저장
            modiPlan.planTitle = self.planTextField.text
            modiPlan.planMemo = self.memoTextView.text
            modiPlan.startDay = self.startDateLabel.text
            modiPlan.endDay = self.endDateLabel.text
            modiPlan.viewColor = self.seletedColor
            
            // 상세 페이지 변경
            let detailVC = parent.children.first as! DetailPlanViewController
            
            detailVC.titleLabel.text = modiPlan.planTitle
            detailVC.dateLabel.text = "\(modiPlan.startDay!) ~ \(modiPlan.endDay!)"
            detailVC.memoTextView.text = modiPlan.planMemo
            
            detailVC.startDay = modiPlan.startDay!
            detailVC.endDay = modiPlan.endDay!
            
            detailVC.setStickBar() 
            
            // DB 업데이트
            DBManager.shared.updatePlan(plan: modiPlan)
        } else { // 추가할 때
            // 플랜을 새로 만들어 저장
            let plan = ModelPlan()
            
            plan.uid = UUID().uuidString
            plan.planTitle = self.planTextField.text
            plan.planMemo = self.memoTextView.text
            plan.startDay = self.startDateLabel.text
            plan.endDay = self.endDateLabel.text
            plan.viewColor = self.seletedColor
        
            // DB에 추가
            DBManager.shared.addPlanDB(plan: plan)
        }
        
        // planList 다시 불러와서 뿌려주기
        parent.planArray = DBManager.shared.selectPlanDB()
        parent.tableView.reloadData()
        
        dismissAlert()
    }
    
    
    
    // 취소 버튼 클릭
    @IBAction func cancelButtonClick(_ sender: Any) {
        dismissAlert()
    }
}



extension AddPlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.startDatePickerHide()
        self.endDatePickerHide()
    }
}



extension AddPlanViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.startDatePickerHide()
        self.endDatePickerHide()
    }
}



