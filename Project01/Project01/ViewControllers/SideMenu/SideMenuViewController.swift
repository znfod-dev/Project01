//
//  SideMenuViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 10..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import SideMenuSwift
import RealmSwift

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class SideMenuViewController: UIViewController {

    @IBOutlet weak var vNavigation: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var arrMenuItem = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // IOS11 이하에서는 마진값 20을 더해준다.
        if #available(iOS 11, *)  {
        }
        else{
            topConstraint.constant = 20
        }
        
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        // 그림자 처리
        vNavigation.layer.shadowColor = UIColor.black.cgColor
        vNavigation.layer.shadowOffset = CGSize(width: 0, height: 1)
        vNavigation.layer.shadowOpacity = 0.1

		// 사이드 메뉴 폭
		SideMenuController.preferences.basic.menuWidth = 270 * scale
		SideMenuController.preferences.basic.defaultCacheKey = "0"
		SideMenuController.preferences.basic.direction = .left
		SideMenuController.preferences.basic.enablePanGesture = false
		
		// 사이드메뉴 설정
        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard.init(name: "Plan", bundle: nil).instantiateViewController(withIdentifier: "_PlannerViewController")            
        }, with: "1")

        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "Setting")
        }, with: "2")

        sideMenuController?.delegate = self
        
        // init Data
        arrMenuItem += [["TITLE":"월간 일정", "IMAGE":""]]
        arrMenuItem += [["TITLE":"계획리스트", "IMAGE":""]]
        arrMenuItem += [["TITLE":"설정", "IMAGE":""]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 프로필 오너 DB체크
//        self.selectOwnerInfoTable()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIButton Action
    // 사이드 메뉴 닫기
    @IBAction func onCloseClick(_ sender: Any) {
        sideMenuController?.hideMenu()
    }
    
    // MARK: - RealmDB SQL Excute
    // 프로필 오너 DB체크
//    func selectOwnerInfoTable() {
//        
//        // 오너 정보 검색
//        let sql = "SELECT * FROM OwnerInfo WHERE uid='1';"
//        // SQL 결과
//        let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
//        let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
//        // 검색 성공
//        if resultCode == "0" {
//            let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
//            // 오너 정보가 없을때...
//            if resultData.count > 0 {
//                let ownerInfo: OwnerInfo = resultData.first as! OwnerInfo
//                
//                lbMessage.text = "\(ownerInfo.surName)\(ownerInfo.name)님의 다이어리 입니다."
//                lbMessage.textColor = UIColor(hex: 0x254EFF)
//            }
//            else {
//                lbMessage.text = "프로필 정보를 설정해주세요!"
//                lbMessage.textColor = UIColor(hex: 0xFF1615)
//            }
//        }
//    }
}


extension SideMenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, animationControllerFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }
    
    func sideMenuWillHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu will hide")
    }
    
    func sideMenuDidHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu did hide.")
    }
    
    func sideMenuWillReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu will show.")
    }
    
    func sideMenuDidReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu did show.")
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrMenuItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SiceMenuCell = tableView.dequeueReusableCell(withIdentifier: "SiceMenuCell", for: indexPath) as! SiceMenuCell
        
        // Configure the cell...
        let dicMenuItem = arrMenuItem[indexPath.row]
        cell.setCellInfo(dicMenuItem)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
         // 월간 일정
        if indexPath.row == 0 {
            print("planner")
            sideMenuController?.setContentViewController(with: "0", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
        }
        // 계획리스트
        else if indexPath.row == 1 {
            sideMenuController?.setContentViewController(with: "1", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
//            print("planner")
//            let storyboard = UIStoryboard.init(name: "Plan", bundle: nil)
//            let plannerVC = storyboard.instantiateViewController(withIdentifier: "_PlannerViewController") as! UINavigationController
//            self.present(plannerVC, animated: true)
        }
        // 설정
        else if indexPath.row == 2 {
            sideMenuController?.setContentViewController(with: "2", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
        }
    }
}
