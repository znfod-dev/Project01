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
import RxSwift
import RxCocoa

class PlannerViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var vNavigationBar: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var addButton: UIView!
    @IBOutlet var searchView: UIView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    
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
    
    var filterPlanArray = Array<ModelPlan>()
    var isModi: Bool? = false
    var plan = ModelPlan() // detailVC로 넘겨줄 plan
    
    var disposeBag = DisposeBag()
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // 데이터 받아 오기
        self.planArray = DBManager.shared.selectPlanDB()
        self.filterPlanArray = self.planArray
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.disposeBag = DisposeBag()
    }
    
    
    
    
    func setUI() {
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.navigationController?.navigationBar.isHidden = true // 내비게이션바 스와이프 기능을 살린채 숨김
        
        // 그림자 처리
        vNavigationBar.layer.shadowColor = UIColor(hex: 0xAAAAAA).cgColor
        vNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 7)
        vNavigationBar.layer.shadowOpacity = 0.16
        
        addButton.layer.shadowColor = UIColor(hex: 0x8578DF).cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        addButton.layer.shadowOpacity = 0.2
        
        self.tableView.separatorStyle = .none // 테이블 뷰 구분선 삭제
        
        searchBar.rx.text
            .orEmpty
            .map { str in
                if str.count == 0 { // 공백이라면 ...
                    self.filterPlanArray = self.planArray
                } else {
                    self.filterPlanArray.removeAll()
                    for plan in self.planArray {
                        if (plan.planTitle?.contains(str))! || (plan.planMemo?.contains(str))! {
                            self.filterPlanArray.append(plan)
                        }
                    }
                }
            }
            .subscribe(onNext: {
                self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    
    
    // searchBar를 숨긴다
    func hideSearchBar() {
        self.searchView.isHidden = true
        self.view.endEditing(true)
        
        // 전체 데이터 세팅
        allPlanSet()
    }
    
    
    
    // 전체 데이터 세팅
    func allPlanSet() {
        searchBar.text = ""
        self.filterPlanArray = self.planArray
        self.tableView.reloadData()
    }
    
    
    
    
    // MARK:- Actions
    @IBAction func menuBtnClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }

    
    
    @IBAction func addButtonClick(_ sender: Any) {
        self.hideSearchBar()
        
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPlanViewController") as! AddPlanViewController
        
        addVC.view.frame = self.view.bounds
        
        self.addChild(addVC)
        self.view.addSubview(addVC.view)
    }
    
    
    
    // 검색 버튼 클릭
    @IBAction func searchBtnClick(_ sender: Any) {
        self.searchView.isHidden = false
    }
    
    
    
    // 취소 버튼 클릭
    @IBAction func cancelBtnClick(_ sender: Any) {
        self.hideSearchBar()
    }
}


extension PlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.planArray.count * 2
        return self.filterPlanArray.count * 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 { // 홀수번째 셀 (공백)
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") as! BlankCell
            return cell
        }
        
        let indexRow = indexPath.row / 2 // 0, 2, 4 ... 데이터를 표시할 셀
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell") as! PlanCell
//        let plan = planArray[indexRow]
        let plan = filterPlanArray[indexRow]
        
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
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row % 2 == 0 { // 짝수번째 셀은 delete 허용
            return true
        } else {
            return false
        }
    }
}


extension PlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexRow = indexPath.row / 2
        
        self.plan = self.filterPlanArray[indexRow]
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailPlanViewController") as! DetailPlanViewController
        detailVC.plan = self.plan
        
        self.view.endEditing(true)
        
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
//            let plan = self.planArray[indexRow]
            let plan = self.filterPlanArray[indexRow]
            
            DBManager.shared.deletePlanDB(plan: plan) {
//                self.planArray.remove(at: indexRow)
                self.filterPlanArray.remove(at: indexRow)
                
                // planArray에서 해당 셀 삭제
                var count = 0
                for _plan in self.planArray {
                    if(plan.uid == _plan.uid) {
                        self.planArray.remove(at: count)
                        break
                    }
                    count += 1
                }
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
