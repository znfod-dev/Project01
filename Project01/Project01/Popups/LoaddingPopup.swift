//
//  LoaddingPopup.swift
//  PlannerDiary
//
//  Created by 김삼현 on 10/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class LoaddingPopup: BasePopup {

	@IBOutlet weak var ivLoadding: UIImageView!
	
    override func viewDidLoad() {
		
		// 딤드뷰 클릭시 팝업 닫아 주는 기능 막기
		self.isNotDimmedTouch = true;

        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.vContent!.backgroundColor = UIColor(patternImage: UIImage(named: "icon_loading.png")!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	public func rotateAnimation(duration: CFTimeInterval = 2.0) {
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(.pi * 2.0)
		rotateAnimation.duration = duration
		rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
		
		self.vContent!.layer.add(rotateAnimation, forKey: nil)
//		self.ivLoadding!.layer.add(rotateAnimation, forKey: nil)
	}
}
