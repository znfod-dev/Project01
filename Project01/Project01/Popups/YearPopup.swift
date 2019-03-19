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
        let idxYear = yearIndex(year: Int(curYYYY))
        pvYear.selectRow(idxYear, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면 갱신
        pvYear.reloadAllComponents()
    }
    
    // 년도 선택 인덱스
    func yearIndex(year: Int) -> Int {
        
        let strYear = "\(year)"
        
        for i in 0..<arrYear.count {
            let curYear = arrYear[i]
            if strYear == curYear {
                return i
            }
        }
        
        return 0
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
            let idxYear = pvYear.selectedRow(inComponent: 0)
            let year = arrYear[idxYear]
            let curYYYY = "\(year)"
            
            confirmAction(Int(curYYYY)!)
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

extension YearPopup: UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrYear.count
    }
    
}

extension YearPopup: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = "\(arrYear[row])년"
        
        let label = view as? UILabel ?? UILabel()
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
            label.textColor = UIColor.black
            label.text = title
            label.textAlignment = .center
        } else {
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
            label.textColor = UIColor.gray
            label.text = title
            label.textAlignment = .center
        }
        
        return label
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let strYear = arrYear[row]
        let curYYYY = Int(String(format: "%@", strYear))
        if curYYYY! < minYYYY {
            // 년도 선택 인덱스
            let idxYear = yearIndex(year: Int(minYYYY))
            pickerView.selectRow(idxYear, inComponent: 0, animated: true)
        }
        else if curYYYY! > maxYYYY {
            // 년도 선택 인덱스
            let idxYear = yearIndex(year: Int(maxYYYY))
            pickerView.selectRow(idxYear, inComponent: 0, animated: true)
        }
        
        pickerView.reloadAllComponents()
    }
}
