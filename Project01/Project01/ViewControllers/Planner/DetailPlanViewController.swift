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
	@IBOutlet weak var vNavigationBar: UIView!
    @IBOutlet var planTitleLabel: UILabel!
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

		// 그림자 처리
		vNavigationBar.layer.shadowColor = UIColor(hex: 0xAAAAAA).cgColor
		vNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 7)
		vNavigationBar.layer.shadowOpacity = 0.16

        self.planTitleLabel.text = plan.planTitle
        self.startDayLabel.text = plan.startDay!
        self.endDayLabel.text = plan.endDay!
    }
    
    
    
    // MARK:- Actions
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
