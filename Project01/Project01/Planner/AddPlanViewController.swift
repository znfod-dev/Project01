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
    
    
    
    // MARK:- Variables
    var selectedDay: Date? = Date()
    
    var startDay: String? = Date().string()
    var endDay: String? = Date().string()
    
    
    
    // MARK:- Constants
    let date = Date()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSet()
    }
    
    
    
    // 초기 세팅
    func initSet() {
        // statusBar 색상 적용
        self.statusBarSet(view: (self.navigationController?.view!)!)
        
        // 오늘 날짜로 세팅
        self.startDayLabel.text = self.startDay
        self.endDayLabel.text = self.endDay
        
        // 날짜 라벨에 탭 버튼 추가
        self.startDayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startDayTap)))
        self.endDayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endDayTap)))
        
        // 디폴트 값 : 종료일 날짜 라벨은 터치가 안됨
        self.endDayLabel.isUserInteractionEnabled = false
        
        // 내비게이션에 저장 버튼 아이템 추가
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveBtnPressed))
    }
    
    
    
    // 달력 알럿을 띄워주는 메소드 (직접입력 제외)
    func presentCalendar() {
        let datePickVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickViewController") as! DatePickViewController
        
        self.addVCAlert(viewController: datePickVC, okTitle: "변경", cancelTitle: "취소") {
            self.selectedDay = datePickVC.selectedDay
            self.startDayLabel.text = self.selectedDay?.string()
            self.dayConvert(index: self.segment)
        }
    }
    
    
    
    // 달력 알럿을 띄워주는 메소드 (직접입력)
    func presentCalendar(label: UILabel, startDayTap: Bool?) {
        let datePickVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickViewController") as! DatePickViewController
        datePickVC.startDayClicked = startDayTap // 시작일 눌렀을 때 true
        
        datePickVC.startDay = self.startDay
        datePickVC.endDay = self.endDay
        
        self.addVCAlert(viewController: datePickVC, okTitle: "변경", cancelTitle: "취소") {
            self.startDay = datePickVC.startDay
            self.endDay = datePickVC.endDay
            self.startDayLabel.text = self.startDay
            self.endDayLabel.text = self.endDay
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
            self.endDayLabel.isUserInteractionEnabled = true
        }
    }
    
    
    
    // 시작일 라벨을 탭했을 때 동작하는 메소드
    @objc func startDayTap() {
        if self.segment.selectedSegmentIndex == 4 { // 직접 입력 클릭 시
            self.presentCalendar(label: self.startDayLabel, startDayTap: true)
        } else { // 직접 입력 제외
            self.presentCalendar()
        }
    }
    
    
    
    // 종료일 라벨을 탭했을 때 동작하는 메소드
    @objc func endDayTap() {
        self.presentCalendar(label: self.endDayLabel, startDayTap: false)
    }
    
    
    
    // 저장 버튼 클릭시
    @objc func saveBtnPressed() {
        let plan = Plan()
        plan.planType = self.segment.selectedSegmentIndex
        plan.planTitle = self.planTextField.text
        plan.startDay = self.startDay
        plan.endDay = self.endDay
        
        DBManager.sharedInstance.addPlanDB(plan: plan)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK:- Actions
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        // 직접입력 클릭시 오늘 날짜로 초기화
        if sender.selectedSegmentIndex == 4 {
            self.startDay = Date().string()
            self.endDay = Date().string()
            self.startDayLabel.text = self.startDay
            self.endDayLabel.text = self.endDay
        } else { // 직접입력 이외에 세그먼트 클릭 시
            self.startDayLabel.text = self.selectedDay?.string()
        }
        
        self.endDayLabel.isUserInteractionEnabled = false
        self.dayConvert(index: sender)
    }
}
