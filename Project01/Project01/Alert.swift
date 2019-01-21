//
//  Alert.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import PopupDialog

// 알럿 extension
extension UIViewController {
    func okAlert(_ title: String?, _ message: String?, completion: (()->Void)? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 200, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: {
                completion?()
            })
            
            alert.addButton(PopupDialogButton(title: "확인", action: {
                completion?()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    
    
    func confirmAlert(_ title: String?, _ message: String?, completion: (()->Void)? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            
            let alert = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
            
            alert.addButton(PopupDialogButton(title: "확인", action: {
                completion?()
            }))
            alert.addButton(PopupDialogButton(title: "취소", action: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    
    
    func addVCAlert(viewController: UIViewController, okTitle: String, cancelTitle: String, completion: (()->Void)? = nil) {
        let alert = PopupDialog(viewController: viewController, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false)
        
        
        alert.addButton(PopupDialogButton(title: okTitle, action: {
            completion?()
        }))
        alert.addButton(PopupDialogButton(title: cancelTitle, action: nil))
        
        self.present(alert, animated: true)
    }
    
    
    
    // statusBar 색상 설정
    func statusBarSet(view: UIView) {
        // statusBar 설정
        let statusBar = UIView()
        
        view.addSubview(statusBar)
        view.bringSubviewToFront(statusBar)
        
        statusBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        
        // 배경 색상 설정
        statusBar.backgroundColor = UIColor(hexString: "#5fc944")
    }
}
