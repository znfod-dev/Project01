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
    @IBOutlet weak var vNavigationBar: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var addButton: UIView!
    
    
    
    // MARK:- Variables
    var planArray = Array<ModelPlan>() {
        willSet(new) {
            if new.count == 0 { // 리스트가 없다면 이미지 표시
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
        }
    }
    
    var isModi: Bool? = false
    var plan = ModelPlan() // detailVC로 넘겨줄 plan
    
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.navigationController?.navigationBar.isHidden = true // 내비게이션바 스와이프 기능을 살린채 숨김
        
        // 그림자 처리
        vNavigationBar.layer.shadowColor = UIColor(hex: 0xAAAAAA).cgColor
        vNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 7)
        vNavigationBar.layer.shadowOpacity = 0.16
        
        self.tableView.separatorStyle = .none // 테이블 뷰 구분선 삭제
        
        // 데이터 받아 오기
        self.planArray = DBManager.shared.selectPlanDB()
    }
    
    
    
    // MARK:- Actions
    @IBAction func menuBtnClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }

    
    
    @IBAction func addButtonClick(_ sender: Any) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        addVC.view.frame = self.view.bounds
        
        self.addChild(addVC)
        self.view.addSubview(addVC.view)
    }
}


extension PlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planArray.count * 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 { // 홀수번째 셀 (공백)
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") as! BlankCell
            return cell
        }
        
        let indexRow = indexPath.row / 2 // 0, 2, 4 ... 데이터를 표시할 셀
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell") as! PlanCell
        let plan = planArray[indexRow]
        
        cell.selectionStyle = .none
        
        // view 테두리 둥글게 처리
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.masksToBounds = true
        
        cell.titleLabel.text = plan.planTitle
        cell.dateLabel.text = "\(plan.startDay!) - \(plan.endDay!)"
        cell.colorView.backgroundColor = UIColor(hexString: plan.viewColor!)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 { // todoCell 높이
            return 74.5            
        } else { // 공백 셀 높이
            return 16.5
        }
    }
}


extension PlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexRow = indexPath.row / 2
        
        self.plan = self.planArray[indexRow]
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailPlanViewController") as! DetailPlanViewController
        detailVC.plan = self.plan
        
        detailVC.view.frame = self.view.bounds
        self.addChild(detailVC)
        self.view.addSubview(detailVC.view)
    }
    
    // 스와이프 delete 액션 세팅
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let indexRow = indexPath.row / 2 // 공백 셀 때문에 실질적으로 0,2,4... 셀이 데이터 셀이다
            let plan = self.planArray[indexRow]
            
            DBManager.shared.deletePlanDB(plan: plan) {
                self.planArray.remove(at: indexRow)
            }
            
            // 테이블뷰 갱신
            self.tableView.reloadData()
        }
        
        action.image = UIImage(named: "icon_cell_delete")
        action.backgroundColor = UIColor(hex: 0x929292)
        
        return action
    }
}


class PlanCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
