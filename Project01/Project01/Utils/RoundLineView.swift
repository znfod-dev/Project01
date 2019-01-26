//
//  RoundLineView.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 4..
//  Copyright © 2019년 sama73. All rights reserved.
//

import Foundation
import UIKit

// Computed properties, based on the backing CALayer property, that are visible in Interface Builder.
@IBDesignable open class RoundLineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        refreshCorners(value: cornerRadius)
        refreshBorderWidth(value: borderWidth)
        refreshColor(color: borderColor)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }
    
    func refreshColor(color: UIColor) {
        clipsToBounds = true
        self.layer.borderColor = color.cgColor
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            refreshBorderWidth(value: borderWidth)
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            refreshColor(color: borderColor)
        }
    }
}
