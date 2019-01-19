//
//  PlannerViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2018. 12. 31..
//  Copyright © 2018년 sama73. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true

        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)

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
    // 사이드 메뉴
    @IBAction func onMenuClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func onAlertCancelClick(_ sender: Any) {
        let popup = AlertMessagePopup.messagePopup(withMessage: "업데이트 후 서비스를 이용해주세요.")
        popup.addActionCancelClick("취소", handler: {
        })
    }

    @IBAction func onAlertConfirmClick(_ sender: Any) {
        let popup = AlertMessagePopup.messagePopup(withMessage: "업데이트 후 서비스를 이용해주세요.")
        popup.addActionConfirmClick("확인", handler: {
        })
    }
    
    @IBAction func onConfirmClick(_ sender: Any) {
        let popup = AlertMessagePopup.messagePopup(withMessage: "로그아웃 하시겠습니까?")
        popup.addActionConfirmClick("확인", handler: {
        })

        popup.addActionCancelClick("취소", handler: {
        })
    }
}
