//
//  TimePickerView.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class TimePickerView: UIView {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    static func initWithNib(frame:CGRect) -> TimePickerView{
        let xibName = "TimePickerView"
        let view:TimePickerView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! TimePickerView
        view.frame = frame
        view.isHidden = true
        DispatchQueue.main.async {
            view.timeBackView.frame.origin.y += view.timeBackView.frame.height
        }
        return view
    }

    @IBAction func submitBtnClicked(_ sender: Any) {
        self.dismissTimePickerView()
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismissTimePickerView()
    }
    func dismissTimePickerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.timeBackView.frame.origin.y += self.timeBackView.frame.height
        }) { success in
            self.isHidden = true
        }
    }
    func showTimePickerView(time:Date) {
        self.isHidden = false
        self.timePicker.date = time
        UIView.animate(withDuration: 0.5, animations: {
            self.timeBackView.frame.origin.y -= self.timeBackView.frame.height
        }) { success in
            
        }
    }
    
}
