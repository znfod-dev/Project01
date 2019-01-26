//
//  DatePickerView.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    private let xibName = "DatePickerView"
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dateBackPicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    static func initWithNib(frame:CGRect) -> DatePickerView{
        let xibName = "DatePickerView"
        let view:DatePickerView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! DatePickerView
        view.frame = frame
        view.isHidden = true
        DispatchQueue.main.async {
            view.dateBackPicker.frame.origin.y += view.dateBackPicker.frame.height
        }
        return view
        
        
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.dismissDatePickerView()
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismissDatePickerView()
    }
    
    func dismissDatePickerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dateBackPicker.frame.origin.y += self.dateBackPicker.frame.height
        }) { success in
            self.isHidden = true
        }
    }
    func showDatePickerView(date:Date) {
        self.datePicker.date = date
        self.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.dateBackPicker.frame.origin.y -= self.dateBackPicker.frame.height
        }) { success in
            
        }
    }
    
}
