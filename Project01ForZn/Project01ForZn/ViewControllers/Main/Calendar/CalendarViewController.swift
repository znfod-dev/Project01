//
//  CalendarViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 17/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss()
    }
    
    override func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeLeftGesture(recognizer)
        let storyboard:UIStoryboard = self.storyboard!
        
        let viewController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "DiaryNavigation") as! UINavigationController
        let rootViewController:DiaryViewController = viewController.viewControllers[0] as! DiaryViewController
        rootViewController.currentDate = Date()
        self.present(viewController)
    }
    override func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeRightGesture(recognizer)
        self.dismiss()
    }

}
