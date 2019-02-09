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
    @IBOutlet var topView: UIView!
    @IBOutlet var startDayLabel: UILabel!
    @IBOutlet var endDayLabel: UILabel!
    
    
    
    // MARK:- Variables
    var plan = ModelPlan()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// sama73 : 375화면 기준으로 스케일 적용
		let scale: CGFloat = DEF_WIDTH_375_SCALE
		view.transform = view.transform.scaledBy(x: scale, y: scale)

        
        self.topView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.5)
        
        self.planTitleLabel.text = plan.planTitle
        self.startDayLabel.text = plan.startDay!
        self.endDayLabel.text = plan.endDay!
    }
    
    
    
    // MARK:- Actions
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
