//
//  PopupManager.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class PopupManager: NSObject {
    
    static let shared = PopupManager()
    
    
    
    
    override init() {
        super.init()
    }
    
    
    func addIndicatorView() {
        let storyboard = AppDelegate.sharedNamedStroyBoard(storyboardName: "Popup")
        let indicatorPopup = storyboard.instantiateViewController(withIdentifier: "IndicatorPopup")
        
        self.addSubView(view: indicatorPopup.view)
    }
    
    // 서브뷰 추가
    func addSubView(view:UIView) -> Int{
        let appDelegate = AppDelegate.sharedAppDelegate()
        let window = appDelegate.window
        view.tag = (window?.subviews.count)!
        window?.addSubview(view)
        return view.tag
    }
    
    // 서브뷰 제거
    func removeSubView(viewNo:Int) -> Bool{
        let appDelegate = AppDelegate.sharedAppDelegate()
        let window = appDelegate.window
        if let subViews = window?.subviews {
            for view in subViews {
                let tag = view.tag
                if tag == viewNo {
                    view.removeFromSuperview()
                    // viewNo 뷰를 제거하는데 성공하면 true를 리턴한다.
                    return true
                }
            }
        }
        return false
    }
    
}
