//
//  Truncater.swift
//  Project01
//
//  Created by 박종현 on 25/05/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class Truncater {
    
    class func replaceElipsis(forLabel label:UILabel, withString replacement:String) -> Bool {
        return replaceElipsis(forLabel: label, withString: replacement, andMaximumWidth:0)
    }
    
    class func replaceElipsis(forLabel label:UILabel, withString replacement:String, andMaximumWidth width:CGFloat) -> Bool {
        
        if(label.text == nil){
            return false
        }
        
        let origSize = label.frame;
        var useWidth = width
        
        if(width <= 0){
            useWidth = origSize.width //use label width by default if width <= 0
        }
        
        label.sizeToFit()
        let labelSize = label.text!.size(withAttributes: [NSAttributedString.Key.font: label.font]) //.size(attributes: [NSFontAttributeName: label.font]) for swift 3
        
        if(labelSize.width > useWidth){
            
            let original = label.text!;
            let truncateWidth = useWidth;
            let font = label.font;
            let subLength = label.text!.characters.count
            
            var temp = label.text!.substringToIndex(label.text!.endIndex.advancedBy(-1)) //label.text!.substring(to: label.text!.index(label.text!.endIndex, offsetBy: -1)) for swift 3
            temp = temp.substringToIndex(temp.startIndex.advancedBy(getTruncatedStringPoint(subLength, original:original, truncatedWidth:truncateWidth, font:font, length:subLength)))
            temp = String.localizedStringWithFormat("%@%@", temp, replacement)
            
            var count = 0
            
            while temp.sizeWithAttributes([NSFontAttributeName: label.font]).width > useWidth {
                
                count+=1
                
                temp = label.text!.substringToIndex(label.text!.endIndex.advancedBy(-(1+count)))
                temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) //remove this if you want to keep whitespace on the end
                temp = String.localizedStringWithFormat("%@%@", temp, replacement)
            }
            
            label.text = temp;
            label.frame = origSize;
            return true;
        }
        else {
            
            label.frame = origSize;
            return false
        }
    }
    
    class func getTruncatedStringPoint(splitPoint:Int, original:String, truncatedWidth:CGFloat, font:UIFont, length:Int) -> Int {
        
        let splitLeft = original.substringToIndex(original.startIndex.advancedBy(splitPoint))
        
        let subLength = length/2
        
        if(subLength <= 0){
            return splitPoint
        }
        
        let width = splitLeft.sizeWithAttributes([NSFontAttributeName: font]).width
        
        if(width > truncatedWidth) {
            return getTruncatedStringPoint(splitPoint: splitPoint - subLength, original: original, truncatedWidth: truncatedWidth, font: font, length: subLength)
        }
        else if (width < truncatedWidth) {
            return getTruncatedStringPoint(splitPoint: splitPoint + subLength, original: original, truncatedWidth: truncatedWidth, font: font, length: subLength)
        }
        else {
            return splitPoint
        }
    }
}

