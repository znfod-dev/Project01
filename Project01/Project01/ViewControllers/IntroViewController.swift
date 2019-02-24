//
//  IntroViewController.swift
//  Project01
//
//  Created by 김삼현 on 08/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

	@IBOutlet weak var ivCloud: UIImageView!
	@IBOutlet weak var ivRefresh: UIImageView!
	var ivRefreshMask: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// 375화면 기준으로 스케일 적용
		let scale: CGFloat = DEF_WIDTH_375_SCALE
		view.transform = view.transform.scaledBy(x: scale, y: scale)

		ivRefreshMask = UIImageView(image: UIImage(named: "img_refresh_mask"))
		ivRefresh.mask = ivRefreshMask
		
		// 리프레쉬 이미지 회전
		rotateAnimation()

		// NotificationCenter에 등록하는 것
		NotificationCenter.default.addObserver(self,  // 추천 항목
			selector: #selector(catchNotification(notification:)), // 통지를받은 때 던지는 메소드
			name: Notification.Name("CloudLoadComplete"), // 통지의 이름
			object: nil)
        
        AppDelegate.sharedAppDelegate()?.accessiCloudData()
       
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Stop listening notification
		NotificationCenter.default.removeObserver(self, name: Notification.Name("CloudLoadComplete"), object: nil)
	}
	
	// 리프레쉬 이미지 회전
	func rotateAnimation(duration: CFTimeInterval = 2.0) {
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(.pi * 2.0)
		rotateAnimation.duration = duration
		rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
		
		self.ivRefreshMask!.layer.add(rotateAnimation, forKey: nil)
		//		self.ivLoadding!.layer.add(rotateAnimation, forKey: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@objc func catchNotification(notification: Notification) -> Void {
		print("Catch notification")
		
		// 알림을받은 취업에 더 가까운 처리를 쓰십시오
		DispatchQueue.main.sync {
			// 앱 최초 실행인지 체크
			let isFisrtAppRun = CommonUtil.getUserDefaultsBool(forKey: kBool_isFirstAppRun)
			// 앱 최초 실행일 경우...
			if isFisrtAppRun == false {
				print("isFisrtAppRun")
				// 앱 최소 실행일 경우 MinDate, MaxDate 설정
				let now = Date()
				let calendar = Calendar.current
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				
				var day = DateComponents(day: -180)
				if let d180 = calendar.date(byAdding: day, to: now)
				{
					DBManager.sharedInstance.saveMinimumDateInUD(minimumDate: Date().startOfMonth(date: d180))
					print("Date().startOfMonth(date: d180) : \(Date().startOfMonth(date: d180))")
					let min = DBManager.sharedInstance.loadMinimumDateFromUD()
					print("min : \(min.description(with: Locale.current))")
				}
				day = DateComponents(day: 180)
				if let d180 = calendar.date(byAdding: day, to: now)
				{
					DBManager.sharedInstance.saveMaximumDateInUD(maximumDate: Date().endOfMonth(date: d180))
					print("Date().endOfMonth(date: d180) : \(Date().endOfMonth(date: d180))")
					let max = DBManager.sharedInstance.loadMaximumDateFromUD()
					print("max : \(max.description(with: Locale.current))")
				}
				CommonUtil.setUserDefaultsBool(true, forKey: kBool_isFirstAppRun)
				
				// 프로필 화면 보여주기
				if let storyboard = AppDelegate.sharedNamedStroyBoard("Profile") as? UIStoryboard {
					
					let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
					profileVC.isFirstAppRun = true
					UIApplication.shared.keyWindow?.rootViewController = profileVC
				}
			}
			else {
				let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController")
				UIApplication.shared.keyWindow?.rootViewController = sideMenuController
                //let storyboard:UIStoryboard = AppDelegate.sharedNamedStroyBoard("Profile") as! UIStoryboard
                //let profileVC: Profile2ViewController = storyboard.instantiateViewController(withIdentifier: "Profile2") as! Profile2ViewController
                //UIApplication.shared.keyWindow?.rootViewController = profileVC
			}
		}
	}
}
