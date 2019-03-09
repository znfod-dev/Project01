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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(self.isModi!)
        if self.isModi! { // 수정이 되었다면 테이블 뷰 리로드
            self.isModi = false // 수정 값을 다시 false
            
            self.planArray = DBManager.shared.selectPlanDB()
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func menuBtnClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addPlanVC = segue.destination as? AddPlanViewController { // 추가 버튼을 눌렀을 때
            addPlanVC.delegate = self
        } else if let detailPlanVC = segue.destination as? DetailPlanViewController { // 디테일 화면으로 넘어갈 때
            detailPlanVC.plan = self.plan
        }
    }
}


extension PlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell") as! PlanCell
        let plan = planArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = plan.planTitle
        cell.timeLabel.text = plan.date?.stringAll()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let plan = self.planArray[indexPath.row]
            DBManager.shared.deletePlanDB(plan: plan) {
                self.planArray.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}


extension PlannerViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.plan = self.planArray[indexPath.row]
		self.performSegue(withIdentifier: "planToDetail", sender: self)
	}
}


class PlanCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 셀의 밑줄을 그린다
        self.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.3, isCell: true)
    }
}
