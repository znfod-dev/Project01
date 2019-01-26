//
//  PickerView.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class PickerView: UIView {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var pickerBackView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    required init?(coder aDecoder: NSCoder) {
        print("aDecoder")
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        print("frame")
        super.init(frame: frame)
    }
    static func initWithNib(frame:CGRect) -> PickerView{
        let xibName = "PickerView"
        let view:PickerView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! PickerView
        view.frame = frame
        view.isHidden = true
        DispatchQueue.main.async {
            view.pickerBackView.frame.origin.y += view.pickerBackView.frame.height
        }
        return view
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.dismissPickerView()
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismissPickerView()
    }
    func dismissPickerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerBackView.frame.origin.y += self.pickerBackView.frame.height
        }) { success in
            self.isHidden = true
        }
    }
    func showPickerView() {
        self.pickerView.reloadComponent(0)
        self.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerBackView.frame.origin.y -= self.pickerBackView.frame.height
        }) { success in
            
        }
    }
    
    
    


}
