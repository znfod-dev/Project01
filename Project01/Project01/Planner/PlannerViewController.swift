//
//  PlannerViewController.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    
    
    
    // MARK:- Variables
    var planArray = Array<Plan>()
    
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.planArray = DBManager.sharedInstance.selectPlanDB()
        self.tableView.reloadData()
    }
    
    
    
    // MARK:- Actions
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addBtnClick(_ sender: Any) {
        let addPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        self.navigationController?.pushViewController(addPlanVC, animated: true)
    }
}



extension PlannerViewController: UITableViewDelegate {
    
}



extension PlannerViewController: UITableViewDataSource {
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
        cell.timeLabel.text = plan.date?.stringAll()
        
        return cell
    }
}