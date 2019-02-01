//
//  PlannerViewController.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import SideMenuSwift
import Hero

class PlannerViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topView: UIView!
    @IBOutlet var emptyView: UIView!
    
    
    
    // MARK:- Variables
    var planArray = Array<Plan>() {
        willSet(new) {
            if new.count == 0 { // 리스트가 없다면 이미지 표시
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
        }
    }
        
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
		// sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.navigationController?.navigationBar.isHidden = true

        self.topView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.3)
        
        self.tableView.separatorStyle = .none
        
        print(NSHomeDirectory())
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.planArray = DBManager.sharedInstance.selectPlanDB()
        self.tableView.reloadData()
    }
    
    
    
    // MARK:- Actions
    @IBAction func menuBtnClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
    
    @IBAction func addBtnClick(_ sender: Any) {
        let addPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        // 화면 넘기는 애니메이션
        addPlanVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .up), dismissing: .slide(direction: .down))
        addPlanVC.hero.isEnabled = true
        
//        self.navigationController?.pushViewController(addPlanVC, animated: true)
        self.present(addPlanVC, animated: true)
    }
}



extension PlannerViewController: UITableViewDelegate {
    
}



extension PlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell") as! PlanCell
        let plan = planArray[indexPath.row]
        
        cell.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.3, isCell: true)
        
        cell.titleLabel.text = plan.planTitle
        cell.timeLabel.text = plan.date?.stringAll()
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Plan", bundle: nil)
        let detailPlanVC = storyboard.instantiateViewController(withIdentifier: "DetailPlanViewController") as! DetailPlanViewController
        detailPlanVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        detailPlanVC.hero.isEnabled = true
        
        let plan = self.planArray[indexPath.row]
        detailPlanVC.plan = plan
        
        self.navigationController?.pushViewController(detailPlanVC, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let plan = self.planArray[indexPath.row]
            DBManager.sharedInstance.deletePlanDB(plan: plan) {
                self.planArray.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}



class PlanCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}
