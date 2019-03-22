//
//  YearMonthPopup.swift
//  Project01
//
//  Created by 김삼현 on 02/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class YearMonthPopup: BasePopup {
    
    @IBOutlet weak var pvYearMonth: UIPickerView!
    @IBOutlet private weak var btnConfirm: UIButton!
    @IBOutlet private weak var btnCancel: UIButton!
    
    private var confirmClick: ((_ curYYYYMM: Int) -> Void)?
    private var cancelClick: (() -> Void)?
    
    var minYYYYMM: Int = 201805
    var maxYYYYMM: Int = 202005
    var curYYYYMM: Int = 201903
    var arrYearMonth: [[String]] = []
    
    override func viewDidLoad() {
        
        // 딤드뷰 클릭시 팝업 닫아 주는 기능 막기
        self.isNotDimmedTouch = true;
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pvYearMonth.showsSelectionIndicator = true
        
        let minYear = Int(minYYYYMM / 100)
        let maxYear = Int(maxYYYYMM / 100)
        
        arrYearMonth = [[], ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]]
        for year in minYear...maxYear {
            arrYearMonth[0].append("\(year)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 년도 선택 인덱스
        let idxYear = yearIndex(year: Int(curYYYYMM / 100))
        let idxMonth = (curYYYYMM % 100) - 1
        pvYearMonth.selectRow(idxYear, inComponent: 0, animated: false)
        pvYearMonth.selectRow(idxMonth, inComponent: 1, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면 갱신
        pvYearMonth.reloadAllComponents()
    }
    
    // 년도 선택 인덱스
    func yearIndex(year: Int) -> Int {
        
        let strYear = "\(year)"
        
        for i in 0..<arrYearMonth[0].count {
            let curYear = arrYearMonth[0][i]
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
    static func yearMonthPopup(curYYYYMM: Int, minYYYYMM: Int, maxYYYYMM: Int) -> YearMonthPopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let yearMonthVC = storyboard?.instantiateViewController(withIdentifier: "YearMonthPopup") as? YearMonthPopup
        // 팝업으로 떳을때
        yearMonthVC!.providesPresentationContextTransitionStyle = true
        yearMonthVC!.definesPresentationContext = true
        yearMonthVC!.modalPresentationStyle = .overFullScreen
        
        // 데이터 세팅
        yearMonthVC!.curYYYYMM = curYYYYMM
        yearMonthVC!.minYYYYMM = minYYYYMM
        yearMonthVC!.maxYYYYMM = maxYYYYMM
        
        BasePopup.addChildVC(yearMonthVC)
        
        return yearMonthVC!
    }
}

extension YearMonthPopup: UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrYearMonth.count
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrYearMonth[component].count
    }
    
}

extension YearMonthPopup: UIPickerViewDelegate {
    
    // The data to return fopr the row and component (column) that's being passed in
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.green : UIColor.black
    //
    //        if component == 0 {
    //            let label = "\(arrYearMonth[component][row])년"
    //            return NSAttributedString(string: label, attributes: [NSForegroundColorAttributeName: color])
    ////            return "\(arrYearMonth[component][row])년"
    //        }
    //        else {
    //            let label = "\(arrYearMonth[component][row])월"
    //            return NSAttributedString(string: label, attributes: [NSForegroundColorAttributeName: color])
    ////            return "\(arrYearMonth[component][row])월"
    //        }
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var title = ""
        // 년
        if component == 0 {
            title = "\(arrYearMonth[component][row])년"
        }
            // 월
        else {
            title = "\(arrYearMonth[component][row])월"
        }
        
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
        
        let strYear = arrYearMonth[0][pickerView.selectedRow(inComponent: 0)]
        let idxRow = pickerView.selectedRow(inComponent: 1) + 1
        let curYYYYMM = Int(String(format: "%@%02d", strYear, idxRow))
        if curYYYYMM! < minYYYYMM {
            // 년도 선택 인덱스
            let idxYear = yearIndex(year: Int(minYYYYMM / 100))
            let idxMonth = (minYYYYMM % 100) - 1
            pickerView.selectRow(idxYear, inComponent: 0, animated: true)
            pickerView.selectRow(idxMonth, inComponent: 1, animated: true)
        }
        else if curYYYYMM! > maxYYYYMM {
            // 년도 선택 인덱스
            let idxYear = yearIndex(year: Int(maxYYYYMM / 100))
            let idxMonth = (maxYYYYMM % 100) - 1
            pickerView.selectRow(idxYear, inComponent: 0, animated: true)
            pickerView.selectRow(idxMonth, inComponent: 1, animated: true)
        }
        
        pickerView.reloadAllComponents()
    }
}
