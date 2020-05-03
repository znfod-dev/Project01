//
//  ZnTextView.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ZnTextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let isFont = self.font else {
            return superRect
            
        }
        
        superRect.size.height = isFont.pointSize - isFont.descender
        superRect.origin.y = superRect.origin.y + isFont.pointSize
        return superRect
    }
    override func firstRect(for range: UITextRange) -> CGRect {
        let superRect = super.firstRect(for: range)
        return superRect
    }
    
    
}
