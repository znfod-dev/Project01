//
//  PlannerViewController.swift
//  Diary
//
//  Created by Byunsangjin on 03/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import PopupDialog

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    
    
    
    // MARK:- Variables
    var planArray = Array<Plan>()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // statusBar 색상 적용
        self.statusBarSet(view: (self.navigationController?.view!)!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.planArray = DBManager.shared.selectPlanDB()
        self.tableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.planArray.count == nil {
            return 0
        }
        
        return self.planArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell") as! PlanCell
        let plan = planArray[indexPath.row]
        
        cell.titleLabel.text = plan.planTitle
        cell.timeLabel.text = Date().stringAll(date: plan.date!)
        
        return cell
    }
    
    
    
    // MARK:- Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Planner", bundle: nil)
        let addPlanVC = storyboard.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        self.navigationController?.pushViewController(addPlanVC, animated: true)
    }
    
}
