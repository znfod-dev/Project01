//
//  CommonUtil.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 4..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class CommonUtil: NSObject {
	
	// 로더 카운트
	static var gLoaderCount: Int = 0
	static var gLoaddingPopup: LoaddingPopup? = nil

	// MARK: - Loader
	// 로더뷰 보이기
	static func showLoaderCount() {
		if CommonUtil.gLoaddingPopup == nil {
			if let storyboard = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard {
				CommonUtil.gLoaddingPopup = storyboard.instantiateViewController(withIdentifier: "LoaddingPopup") as? LoaddingPopup
			}
		}
		
		if CommonUtil.gLoaderCount == 0 {
			// 팝업으로 떳을때
			if let loaddingPopup = CommonUtil.gLoaddingPopup {
				loaddingPopup.providesPresentationContextTransitionStyle = true
				loaddingPopup.definesPresentationContext = true
				loaddingPopup.modalPresentationStyle = .overFullScreen
				
				DispatchQueue.main.async(execute: {
					BasePopup.addChildVC(loaddingPopup)
					loaddingPopup.rotateAnimation()
				})
			}
		}
		
		// 스케쥴 종료
		CommonUtil.self.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hideLoaderClear), object: nil)
		
		// 스케쥴 시작
//		CommonUtil.self.perform(#selector(self.hideLoaderClear), with: nil, afterDelay: 30.0)
		CommonUtil.self.perform(#selector(self.hideLoaderClear), with: nil, afterDelay: 5.0)
		
		CommonUtil.gLoaderCount+=1
	}
	
	// 로더뷰 숨기기
	static func hideLoaderCount() {
		CommonUtil.gLoaderCount-=1
		if CommonUtil.gLoaderCount <= 0 {
			CommonUtil.hideLoaderClear()
			
			// 스케쥴 종료
			CommonUtil.self.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hideLoaderClear), object: nil)
		}
	}
	
	// 타임 아웃 되었을때 로더 초기화
	@objc static func hideLoaderClear() {
		CommonUtil.gLoaderCount = 0
		
		DispatchQueue.main.async(execute: {
			if let loaddingPopup = CommonUtil.gLoaddingPopup {
				loaddingPopup.removeFromParentVC()
			}
		})
	}
	
    // MARK: - empty
    // 리턴값이 YES이면 null 종류의 값이다.
    static func isEmpty(_ emptyCheck: AnyObject?) -> Bool {
        
        if emptyCheck == nil {
            return true
        }
        else if emptyCheck == nil {
            return true
        }
        else if emptyCheck is NSNull {
            return true
        }
        else if emptyCheck is String && emptyCheck?.isEqual(to: "") == true {
            return true
        }
        
        return false
    }
    
    // MARK: - Device
    // iPhoneX인지 체크
    static var isIphoneX : Bool {
		
        get {
            guard #available(iOS 11.0, *) else {
                return false
            }

            print(UIApplication.shared.windows[0].safeAreaInsets)
            if(UIApplication.shared.windows[0].safeAreaInsets.bottom != 0.0) {
                return true
            }
            
            return false
        }
    }
}
