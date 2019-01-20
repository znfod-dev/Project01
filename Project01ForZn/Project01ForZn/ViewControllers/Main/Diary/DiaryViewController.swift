//
//  DiaryViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 17/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var currentDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currentDate : \(self.currentDate)")
        self.setTableSetting()
    }
    
    func setTableSetting() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss()
    }
    
    override func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeLeftGesture(recognizer)
        
    }
    override func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeRightGesture(recognizer)
        self.dismiss()
        
    }

}
