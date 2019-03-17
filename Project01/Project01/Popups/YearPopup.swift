//
//  YearPopup.swift
//  Project01
//
//  Created by 박종현 on 17/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class YearPopup: BasePopup {

    @IBOutlet weak var pvYear: UIPickerView!
    @IBOutlet private weak var btnConfirm: UIButton!
    @IBOutlet private weak var btnCancel: UIButton!
    
    private var confirmClick: ((_ curYYYY: Int) -> Void)?
    private var cancelClick: (() -> Void)?
    
    var minYYYY: Int = 2018
    var maxYYYY: Int = 2020
    var curYYYY: Int = 2019
    var arrYear: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // 딤드뷰 클릭시 팝업 닫아 주는 기능 막기
        self.isNotDimmedTouch = true;
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pvYear.showsSelectionIndicator = true
        
        let minYear = Int(minYYYY)
        let maxYear = Int(maxYYYY)
        
        for year in minYear...maxYear {
            arrYear.append("\(year)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 년도 선택 인덱스
        let idxYear = yearIndex(year: Int(curYYYY)
        pvYear.selectRow(idxYear, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면 갱신
        pvYear.reloadAllComponents()
    }
    
    func addActionConfirmClick(handler ConfirmClick: @escaping (_ curYYYYMM: Int) -> Void) {
        
        confirmClick = ConfirmClick
    }
    
    func addActionCancelClick(handler CancelClick: @escaping () -> Void) {
        
        cancelClick = CancelClick
    }
    // MARK: - UIButton Action
    // 확인 버튼
    @IBAction func onConfirmClick(_ sender: Any) {
        callbackWithConfirm()
    }
    
    // 취소 버튼
    @IBAction func onCancelClick(_ sender: Any) {
        callbackWithCancel()
    }
    
    // MARK: - Callback Event
    func callbackWithConfirm() {
        
        if let confirmAction = confirmClick {
            let idxYear = pvYearMonth.selectedRow(inComponent: 0)
            let idxMonth = pvYearMonth.selectedRow(inComponent: 1)
            let year = arrYearMonth[0][idxYear]
            let month = arrYearMonth[1][idxMonth]
            let curYYYYMM = "\(year)\(month)"
            
            confirmAction(Int(curYYYYMM)!)
        }
        
        removeFromParentVC()
    }
    
    func callbackWithCancel() {
        
        if let cancelAction = cancelClick {
            cancelAction()
        }
        
        removeFromParentVC()
    }

    // MARK: - Class Method
    /**
     message : 메세지
     */
    static func yearPopup(curYYYY: Int, minYYYY: Int, maxYYYY: Int) -> YearPopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let yearVC = storyboard?.instantiateViewController(withIdentifier: "YearPopup") as? YearPopup
        // 팝업으로 떳을때
        yearVC!.providesPresentationContextTransitionStyle = true
        yearVC!.definesPresentationContext = true
        yearVC!.modalPresentationStyle = .overFullScreen
        
        // 데이터 세팅
        yearVC!.curYYYY = curYYYY
        yearVC!.minYYYY = minYYYY
        yearVC!.maxYYYY = maxYYYY
        
        BasePopup.addChildVC(yearVC)
        
        return yearVC!
    }
}
