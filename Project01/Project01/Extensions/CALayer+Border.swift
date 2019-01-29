//
//  CALayer+Border.swift
//  Project01
//
//  Created by Byunsangjin on 29/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

// 각 방향의 Border 주기
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat, isCell: Bool? = false) {
        let deviceWidth = AppDelegate.sharedAppDelegate()?.deviceWidth
        
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: deviceWidth!, height: width)
                break
            case UIRectEdge.bottom:
                if isCell! { // 셀일 경우 앞뒤로 마진을 준다.
                    let margin = deviceWidth! / 30
                    border.frame = CGRect.init(x: margin, y: frame.height - width, width: deviceWidth! - margin * 2, height: width)
                } else {
                    border.frame = CGRect.init(x: 0, y: frame.height - width, width: deviceWidth!, height: width)
                }
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: deviceWidth! - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
