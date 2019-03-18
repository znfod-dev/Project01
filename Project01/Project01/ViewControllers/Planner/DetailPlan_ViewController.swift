//
//  DetailPlan_ViewController.swift
//  Project01
//
//  Created by Byunsangjin on 14/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DetailPlan_ViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var detailView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var memoTextView: UITextView!
    
    // MARK:- Constants
    var plan: ModelPlan = ModelPlan()
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        print("ViewDidLoad")
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        print(plan.uid)
        self.titleLabel.text = plan.planTitle
        self.dateLabel.text = "\(plan.startDay!) ~ \(plan.endDay!)"
        self.memoTextView.text = plan.planMemo
    }
    
    
    
    // MARK:- Actions
    @IBAction func okButtonClick(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    
    @IBAction func modiButtonClick(_ sender: Any) {
        let addPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlan_ViewController") as! AddPlan_ViewController
        
        addPlanVC.modiPlan = self.plan
//        addPlanVC.isModify = true
        
        parent?.addChild(addPlanVC)
        parent?.view.addSubview(addPlanVC.view)
    }
    
}
