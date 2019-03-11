//
//  DiaryViewController+TextView.swift
//  Project01
//
//  Created by 박종현 on 11/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
extension DiaryViewController: UITextViewDelegate {
    // MARK:- UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: 200))
        let estimatedHeight = newSize.height > 16 ? newSize.height : 16
        
        textView.frame = CGRect.init(x: 22, y: 50, width: textView.frame.width, height: estimatedHeight)
        
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
}
