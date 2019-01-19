//
//  Utils.swift
//  Diary
//
//  Created by Byunsangjin on 10/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import Foundation
import PopupDialog

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




// Date값을 String으로 변환
extension Date {
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let day = formatter.string(from: self)
        return day
    }
    
    func stringAll(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let day = formatter.string(from: date)
        return day
    }
    
    // 전달의 마지막 날
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번달의 마지막 날
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    // 이번주의 시작 날 (일요일)
    func startOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    // 이번주의 마지막 날 (토요일)
    func endOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)!
    }
    
    // 전년도 마지막 날 (12-31)
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번년도 마지막 날 (12-31)
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
}



// UIColor Extension
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}



extension Bool {
    func string() -> String {
        return String(self)
    }
}



extension String {
    func bool() -> Bool {
        return Bool(self)!
    }
}
