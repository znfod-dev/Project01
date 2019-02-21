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

	@IBOutlet weak var ivIcon: UIImageView!
	var ivIconMask: UIImageView!
	
    @IBOutlet weak var lbMessage: UILabel!
	
	@IBOutlet weak var vCalendar: UIView!
	@IBOutlet weak var vPlanlist: UIView!
	@IBOutlet weak var vDiary: UIView!
	@IBOutlet weak var vSetting: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        // 그림자 처리
        vCalendar.layer.shadowColor = UIColor.black.cgColor
        vCalendar.layer.shadowOffset = CGSize(width: 0, height: 2)
        vCalendar.layer.shadowOpacity = 0.2
		vPlanlist.layer.shadowColor = UIColor.black.cgColor
		vPlanlist.layer.shadowOffset = CGSize(width: 0, height: 2)
		vPlanlist.layer.shadowOpacity = 0.2
		vDiary.layer.shadowColor = UIColor.black.cgColor
		vDiary.layer.shadowOffset = CGSize(width: 0, height: 2)
		vDiary.layer.shadowOpacity = 0.2
		vSetting.layer.shadowColor = UIColor.black.cgColor
		vSetting.layer.shadowOffset = CGSize(width: 0, height: 2)
		vSetting.layer.shadowOpacity = 0.2

		// 사이드 메뉴 폭
		SideMenuController.preferences.basic.menuWidth = DEF_SCREEN_375_WIDTH * scale
		SideMenuController.preferences.basic.defaultCacheKey = "0"
		SideMenuController.preferences.basic.direction = .left
		SideMenuController.preferences.basic.enablePanGesture = false
		
		// icon
		ivIconMask = UIImageView(image: UIImage(named: "menu_icon_mask"))
		ivIcon.mask = ivIconMask
		
		// 사이드메뉴 설정
        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard.init(name: "Plan", bundle: nil).instantiateViewController(withIdentifier: "_PlannerViewController")            
        }, with: "1")

        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "Setting")
        }, with: "2")

        sideMenuController?.delegate = self
        
        // init Data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		// 사이드 메뉴 열때...
		if sideMenuController?.isMenuRevealed == false {
			// 아이콘 이미지 회전
			rotateAnimation()

			// 프로필 정보 DB체크
			self.selectDBProfile()
		}
		// 사이드 메뉴 닫을때...
		else {
			self.ivIcon.layer.removeAllAnimations()
			self.ivIconMask.layer.removeAllAnimations()
		}
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	// 아이콘 이미지 회전
	func rotateAnimation(duration: CFTimeInterval = 2.0) {
		// 아이콘 이미지
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(.pi * 2.0)
		rotateAnimation.duration = duration
		rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
		
		self.ivIcon!.layer.add(rotateAnimation, forKey: nil)
		
		// 마스크
		let rotateAnimation2 = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation2.fromValue = 0.0
		rotateAnimation2.toValue = -CGFloat(.pi * 2.0)
		rotateAnimation2.duration = duration
		rotateAnimation2.repeatCount = Float.greatestFiniteMagnitude;
		
		self.ivIconMask!.layer.add(rotateAnimation2, forKey: nil)
	}

	
    // MARK: - UIButton Action
    // 사이드 메뉴 닫기
    @IBAction func onCloseClick(_ sender: Any) {
        sideMenuController?.hideMenu()
    }
	
	// 프로필 설정
	@IBAction func onProfileSettingClick(_ sender: Any) {
		// 프로필 화면 보여주기
		if let storyboard = AppDelegate.sharedNamedStroyBoard("Profile") as? UIStoryboard {
			
			let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
			// 모달 설정
			profileVC.isModal = true
			self.present(profileVC, animated: true, completion: nil)
		}
	}
	
	// 셀 클릭
	@IBAction func onSelectRowAtClick(_ sender: UIButton) {
		let tag = sender.tag
		// 계획리스트
		if tag == 1 {
			sideMenuController?.setContentViewController(with: "1", animated: Preferences.shared.enableTransitionAnimation)
			sideMenuController?.hideMenu()
		}
		// 다이어리
		else if tag == 2 {
		}
		// 설정
		else if tag == 3 {
			sideMenuController?.setContentViewController(with: "2", animated: Preferences.shared.enableTransitionAnimation)
			sideMenuController?.hideMenu()
		}
		// 월간 일정
		else {
			sideMenuController?.setContentViewController(with: "0", animated: Preferences.shared.enableTransitionAnimation)
			sideMenuController?.hideMenu()
		}
	}
	
    // MARK: - RealmDB SQL Excute
    // 프로필 정보 DB체크
    func selectDBProfile() {
        
        // 이름
        var name: String = ""
        // 성
        var surname: String = ""

        // 오너 정보 검색
        let sql = "SELECT * FROM ModelDBProfile;"
        // SQL 결과
        let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
        let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
        // 검색 성공
        if resultCode == "0" {
            let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
            if resultData.count > 0 {
                let profileInfo: ModelDBProfile = resultData.first as! ModelDBProfile
                name = profileInfo.name!
                surname = profileInfo.surname!
            }
        }
        
        // 성, 이름중 빈문자열이 아닐 경우
        if CommonUtil.isEmpty(surname as AnyObject) == false || CommonUtil.isEmpty(name as AnyObject) == false {
/*
			// 글자 속성 지정
			let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]
			let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
			
			let strAttributed1 = NSMutableAttributedString(string:"\(surname)\(name)님", attributes:attrs1)
			let strAttributed2 = NSMutableAttributedString(string:"의\n", attributes:attrs2)
			let strAttributed3 = NSMutableAttributedString(string:"다이어리", attributes:attrs1)
			let strAttributed4 = NSMutableAttributedString(string:"입니다.", attributes:attrs2)
			
			strAttributed1.append(strAttributed2)
			strAttributed1.append(strAttributed3)
			strAttributed1.append(strAttributed4)
			
			// 글자 자간 조정
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 8
			strAttributed1.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, strAttributed1.length))
			lbMessage.attributedText = strAttributed1;
*/
			lbMessage.text = "\(surname)\(name)님"
        }
        else {
            lbMessage.text = "프로필 정보를 설정해주세요!"
        }
    }
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
