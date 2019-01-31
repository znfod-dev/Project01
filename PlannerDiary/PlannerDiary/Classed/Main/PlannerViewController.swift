//
//  PlannerViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2018. 12. 31..
//  Copyright © 2018년 sama73. All rights reserved.
//

import UIKit
import RealmSwift

class PlannerViewController: UIViewController {

	@IBOutlet var vPageControl: CustomPageControlView!
	@IBOutlet weak var vPageControlWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true

        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
		
		// 간격
		let gapWidth: CGFloat = 10.0
		// 페이지 컨트롤
		vPageControl.gapWidth = gapWidth
		vPageControl.normalItem = UIColor(hex: 0xff0000)
		vPageControl.selectedItem = UIColor(hex: 0xff0000)
		vPageControl.setTotalPage(3)
		// 10px : 이미지 크기 8px 이미지 간격
		vPageControlWidthConstraint.constant = (vPageControl.frame.size.height * 3) + gapWidth * 2
		
		vPageControl.isHidden = false
//		vPageControl.setSelectPage(0)
		
		
//		if view_count > 1 {
//			vPageControl.totalPage = view_count
//			// 10px : 이미지 크기 8px 이미지 간격
//			vPageControlWidthConstraint.constant = (vPageControl.frame.size.height * view_count) + 10 * (view_count - 1)
//
//			vPageControl.hidden = false
//			vPageControl.selectPage = index_delete
//		} else {
//			vPageControl.hidden = true
//		}

    }
    
	// 팝업 메세지 스케쥴
	@objc func showPopupMessage(_ message: String?) {
		if CommonUtil.isEmpty(message as AnyObject) {
			return
		}
		
		let popup = AlertMessagePopup.messagePopup(message: message)
		popup.addActionConfirmClick("확인", handler: {
			
		})
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
		
		var dicConfig: [String: Any] = [:]
		dicConfig["TITLE"] = "Phone Setting"
		dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.phonePad

		let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick("확인") { (message) in
			self.perform(#selector(self.showPopupMessage(_:)), with: message, afterDelay: 0.1)
		}
		
		popup.addActionCancelClick("취소", handler: {
		})
    }

    @IBAction func onAlertConfirmClick(_ sender: Any) {
		var dicConfig: [String: Any] = [:]
		dicConfig["TITLE"] = "Email Setting"
		dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.emailAddress
		
		let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick("확인") { (message) in
			self.perform(#selector(self.showPopupMessage(_:)), with: message, afterDelay: 0.1)
		}
		
		popup.addActionCancelClick("취소", handler: {
		})
    }
    
    @IBAction func onConfirmClick(_ sender: Any) {
        let popup = AlertMessagePopup.messagePopup(message: "업데이트 하시겠습니까?")
        popup.addActionConfirmClick("확인", handler: {
            
        })
        popup.addActionCancelClick("취소", handler: {
            
        })
/*
		var dicConfig: [String: Any] = [:]
		dicConfig["TITLE"] = "URL Setting"
		dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.URL
		
		let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick("확인") { (message) in
			self.perform(#selector(self.showPopupMessage(_:)), with: message, afterDelay: 0.1)
		}
		
		popup.addActionCancelClick("취소", handler: {
		})
 */
    }
    
    @IBAction func onHoliday1Click(_ sender: Any) {
        // 공공데이터 포털 API호출
        let param: [String: Any] = AlamofireHelper.requestParameters()

        // 공휴일 체크
        self.requestHoliday(year: 2019, month: 1, parameters: param)
    }
    
    @IBAction func onHoliday2Click(_ sender: Any) {
        // 공공데이터 포털 API호출
        var param: [String: Any] = AlamofireHelper.requestParameters()
        param["isNotShowLoader"] = true

        // 공휴일 체크
        self.requestHoliday(year: 2019, month: 1, parameters: param)
    }
    
    // MARK: - RESTfull API
    // 공휴일 체크
    func requestHoliday(year:Int, month:Int, parameters: [String: Any]? = nil) {
 
        var parameters = parameters
        
        parameters!["ServiceKey"] = kServiceKey_AUTHKEY
        parameters!["solYear"] = "\(year)"
        parameters!["solMonth"] = String(format: "%02d", month)
        //        param["_type"] = "json"
//        print(parameters!)
        
        AlamofireHelper.requestGET(kMonthHoliday_URL, parameters: parameters, success: { (jsonData) in
            
            guard let jsonData = jsonData else {
                return
            }
            
            print(jsonData)
            let response: [String: Any]? = (jsonData["response"] as! [String : Any])
            if CommonUtil.isEmpty(response as AnyObject) { return }
            
            let body: [String: Any]? = response!["body"] as? [String : Any]
            if CommonUtil.isEmpty(body as AnyObject) { return }
            
            let totalCount: Int = body!["totalCount"] as? Int ?? 0
            if totalCount == 0 {

            }
                // 딕셔너리
            else if totalCount == 1 {
                let items: [String: Any]? = body!["items"] as? [String : Any]
                if CommonUtil.isEmpty(items as AnyObject) { return }
                
                let item: [String: Any]? = items!["item"] as? [String: Any]
                if CommonUtil.isEmpty(item as AnyObject) { return }
                
                let dateName: String = item!["dateName"] as! String
                let locdate: Int = item!["locdate"] as! Int
                print("dateName = \(dateName), locdate = \(locdate)")
                
                let message: String = "\(locdate) - \(dateName) 공휴일"
                let popup = AlertMessagePopup.messagePopup(message: message)
                popup.addActionConfirmClick("확인", handler: {
                    
                })
                
            }
                // 배열
            else {
                let items: [String: Any]? = body!["items"] as? [String : Any]
                if CommonUtil.isEmpty(items as AnyObject) { return }
                
                let item: [[String: Any]]? = items!["item"] as? [[String: Any]]
                if CommonUtil.isEmpty(item as AnyObject) { return }
                
                for holiday:[String: Any] in item! {
                    let dateName: String = holiday["dateName"] as! String
                    let locdate: Int = holiday["locdate"] as! Int
                    print("dateName = \(dateName), locdate = \(locdate)")
                    
                }
            }
        }) { (error) in
            //            print(error!)
        }
    }
}
