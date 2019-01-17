//
//  IndicatorPopupViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class IndicatorPopupViewController: PopupViewController {
    
    
    @IBOutlet var indicatorImageView: UIImageView!
    
    @IBOutlet var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet var indicatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
}
