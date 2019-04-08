//
//  DetailPlan_ViewController.swift
//  Project01
//
//  Created by Byunsangjin on 14/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DetailPlanViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var detailView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var memoTextView: UITextView!
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var stickBar: UIView!
    @IBOutlet var hideStickWidth: NSLayoutConstraint!
    
    @IBOutlet var dDayLabel: UILabel!
    
    
    
    
    // MARK:- Constants
    let stickWidth:Float = 249
    
    
    
    // MARK:- Variables
    var plan: ModelPlan = ModelPlan()
    var startDay: String?
    var endDay: String?
    var totalDate: Float?
    var remainDate: Float?
    
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.startDay = plan.startDay!
        self.endDay = plan.endDay!
        
        self.titleLabel.text = plan.planTitle
        self.dateLabel.text = "\(startDay!) ~ \(endDay!)"
        self.memoTextView.text = plan.planMemo
        
        self.setStickBar()
    }
    
    
    
    func setStickBar() {
        self.totalDate = Float(Date().dateGap(startDay: startDay!, endDay: endDay!))
        self.remainDate = Float(Date().dateGap(startDay: Date().string(), endDay: endDay!))
        
        if Int(self.remainDate!) > 0 { // 아직 도달 못함
            self.dDayLabel.text = "D-\(Int(remainDate!))"
            let progressRatio = (remainDate! / totalDate!) <= 1 ? (remainDate! / totalDate!) : 1
            
            hideStickWidth.constant = CGFloat(self.stickWidth * progressRatio)
            print(CGFloat(self.stickWidth * (remainDate! / totalDate!)))
            print(hideStickWidth.constant)
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func okButtonClick(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    
    @IBAction func modiButtonClick(_ sender: Any) {
        let addPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        addPlanVC.modiPlan = self.plan
        
        addPlanVC.view.frame = (parent?.view.bounds)!
        parent?.addChild(addPlanVC)
        parent?.view.addSubview(addPlanVC.view)
    }
    
}
