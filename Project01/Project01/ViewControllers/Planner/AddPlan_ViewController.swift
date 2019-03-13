//
//  AddPlan_ViewController.swift
//  Project01
//
//  Created by Byunsangjin on 12/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class AddPlan_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 375화면 기준으로 스케일 적용
//        let scale: CGFloat = DEF_WIDTH_375_SCALE
//        view.transform = view.transform.scaledBy(x: scale, y: scale)
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    

}
