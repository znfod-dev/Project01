//
//  SettingViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 11..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // 프로필 설정
    @IBAction func onProfileClick(_ sender: Any) {
        if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
            if let profileVC: ProfileViewController = (storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController) {
                self.present(profileVC, animated: true)
            }
        }
        
        sideMenuController?.hideMenu()
    }
}
