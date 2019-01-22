//
//  DetailPlanViewController.swift
//  Project01
//
//  Created by Byunsangjin on 22/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DetailPlanViewController: UIViewController {
    // MARK:- Actions
    @IBOutlet var planTitleLabel: UILabel!
    @IBOutlet var planTermLabel: UILabel!
    
    
    
    // MARK:- Variables
    var plan = Plan()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.planTitleLabel.text = plan.planTitle
        self.planTermLabel.text = "\(plan.startDay!) ~ \(plan.endDay!)"
    }
}
