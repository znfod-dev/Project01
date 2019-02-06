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
        print("caretRect : \(superRect)")
        guard let isFont = self.font else {
            print("caretRect update : \(superRect)")
            return superRect
            
        }
        
        superRect.size.height = isFont.pointSize - isFont.descender
        superRect.origin.y = superRect.origin.y + isFont.pointSize
        print("caretRect update : \(superRect)")
        return superRect
    }
    override func firstRect(for range: UITextRange) -> CGRect {
        print("firstRect")
        let superRect = super.firstRect(for: range)
        return superRect
    }
    
    //let selectionRange = self.selectedTextRange
    //let selectionStartRect = self.caretRect(for: (selectionRange?.start)!)
    //let selectionEndRect = self.caretRect(for: (selectionRange?.end)!)
    
    
}
