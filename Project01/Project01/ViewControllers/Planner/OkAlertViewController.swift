//
//  OkAlertViewController.swift
//  Project01
//
//  Created by Byunsangjin on 13/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class OkAlertViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var alertView: UIView!
    @IBOutlet var alertMessageLabel: UILabel!
    @IBOutlet var okButton: UIButton!
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    
    
    func setTitle(message: String) {
        self.alertMessageLabel.text = message
    }

    
    
    // MARK:- Actions
    @IBAction func okButtonClick(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
