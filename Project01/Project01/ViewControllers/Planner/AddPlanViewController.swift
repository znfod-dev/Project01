//
//  AddPlanViewController.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class AddPlanViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var planTextField: UITextField!
    @IBOutlet var startDayLabel: UILabel!
    @IBOutlet var endDayLabel: UILabel!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var topView: UIView!
    
    
    
    // MARK:- Variables
    var selectedDay: Date? = Date()
    
    var startDay: String? = Date().string()
    var endDay: String? = Date().string()
    
    var delegate: PlannerViewController? // 데이터 값을 넘기기위한 델리게이트
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// sama73 : 375화면 기준으로 스케일 적용
		let scale: CGFloat = DEF_WIDTH_375_SCALE
		view.transform = view.transform.scaledBy(x: scale, y: scale)

        self.initSet()
    }
    
    
    
    // 초기 세팅
    func initSet() {
        self.topView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.3)
        
        // 오늘 날짜로 세팅
        self.startDayLabel.text = self.startDay
        self.endDayLabel.text = self.endDay
        
        // 날짜 라벨에 탭 버튼 추가
        self.startDayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startDayTap)))
        self.endDayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endDayTap)))
    }
    
    
    
    // 달력 알럿을 띄워주는 메소드 (직접입력 제외)
    func presentCalendar(startDayClicked: Bool = false) {
        let storyboard = UIStoryboard.init(name: "Plan", bundle: nil)
        let datePickVC = storyboard.instantiateViewController(withIdentifier: "DatePickViewController") as! DatePickViewController
        
        datePickVC.startDayClicked = startDayClicked // 시작일 선택인지 아닌지 판단하는 변수
        
        datePickVC.startDay = self.startDay
        datePickVC.endDay = self.endDay
        datePickVC.selectedDay = self.selectedDay
        
        self.addVCAlert(viewController: datePickVC, okTitle: "변경", cancelTitle: "취소") {
            self.startDay = datePickVC.startDay
            self.endDay = datePickVC.endDay
            self.selectedDay = datePickVC.selectedDay
            
            self.startDayLabel.text = self.startDay
            self.endDayLabel.text = self.endDay
            self.dayConvert(index: self.segment)
        }
    }
    
    
    
    // 세그먼트에 따라 종료일을 다르게 해주는 메소드
    func dayConvert(index sender: UISegmentedControl ) {
        switch sender.selectedSegmentIndex {
        case 0: // 일
            self.endDayLabel.text = self.startDayLabel.text
        case 1: // 주
            self.endDayLabel.text = self.selectedDay?.endOfWeek()?.string()
        case 2: // 월
            self.endDayLabel.text = self.selectedDay?.endOfMonth().string()
        case 3: // 년
            self.endDayLabel.text = self.selectedDay?.endOfYear().string()
        default: // 직접 설정
            if self.startDay! > self.endDay! {
                self.endDayLabel.text = self.startDayLabel.text
            }
        }
    }
    
    
    
    // 시작일 라벨을 탭했을 때 동작하는 메소드
    @objc func startDayTap() {
        self.presentCalendar(startDayClicked: true)
    }
    
    
    
    // 종료일 라벨을 탭했을 때 동작하는 메소드
    @objc func endDayTap() {
        self.segment.selectedSegmentIndex = 4 // 직접 입력 탭으로 변경
        self.presentCalendar()
    }
    
    
    
    // MARK:- Actions
    // segment를 눌렀을 때
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        self.startDayLabel.text = self.startDay
        self.dayConvert(index: sender)
    }
    
    
    
    // 저장 버튼 클릭시
    @IBAction func saveBtnPressed() {
        guard !(planTextField.text?.isEmpty)! else { // 계획이 텍스트필드가 비어있다면
            self.okAlert("계획을 입력해 주세요", nil)
            return
        }
        
        let plan = ModelPlan()
        plan.planType = self.segment.selectedSegmentIndex
        plan.planTitle = planTextField.text
        plan.startDay = self.startDayLabel.text
        plan.endDay = self.endDayLabel.text
        
        DBManager.sharedInstance.addPlanDB(plan: plan)
        
        delegate?.isModi = true
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
}
