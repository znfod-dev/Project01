//
//  FontManager.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class FontManager: NSObject {
    static let shared = FontManager()
    
    // 폰트
    var fontType:FontType!
    // 사이즈
    var fontSize:CGFloat = 20.0
    
    // 줄간격
    var paragraph:NSParagraphStyle = NSParagraphStyle.init()
    // AttributedString
    var textAttributes:[NSAttributedString.Key:Any] = [
        NSAttributedString.Key.paragraphStyle : NSParagraphStyle.init()
    ]
    
    override init() {
        super.init()
        let loadedFont = DBManager.sharedInstance.loadFontFromUD()
        self.fontType = FontType(rawValue: loadedFont.fontName)
        self.fontSize = loadedFont.pointSize
        
        self.updateTextAttributes()
    }
    
    
    func printFontList() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    func setFontType(fontType:FontType) {
        self.fontType = fontType
        self.updateTextAttributes()
        
        DBManager.sharedInstance.saveFontInUD(font: UIFont(name: fontType.ttf(), size: self.fontSize)!)
    }
    func getFontType() -> FontType {
        return self.fontType
    }
    
    func updateTextAttributes() {
        let font = UIFont(name: fontType.ttf(), size: self.fontSize)!
        let lineHeight = getLineHeight()
        let paragraph:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = 0
        paragraph.minimumLineHeight = lineHeight
        self.textAttributes.updateValue(paragraph, forKey: NSAttributedString.Key.paragraphStyle)
        self.textAttributes.updateValue(font, forKey: NSAttributedString.Key.font)
    }
    
    func getTextWithFont(text:String) -> NSAttributedString {
        
        return NSAttributedString(string: text, attributes: self.textAttributes)
    }
    // 지금 사용하는 UIFont를 반환한다. ( font와 fontsize를 사용 )
    func getTextFont() -> UIFont {
        return UIFont(name: fontType.ttf(), size: self.fontSize)!
    }
    //
    func getTextSize(text:String) -> CGSize{
        let size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font:self.getTextFont()])
        return size
    }
    
    
    func setFontSize(size:CGFloat) {
        self.fontSize = size
        self.updateTextAttributes()
        DBManager.sharedInstance.saveFontInUD(font: UIFont(name: fontType.ttf(), size: self.fontSize)!)
    }
    func getFontSize() -> CGFloat {
        return self.fontSize
    }
    
    func getLineHeight() -> CGFloat {
        var lineHeight:CGFloat = 44
        if fontSize == 20 {
            lineHeight = 44
        }else if fontSize == 18 {
            lineHeight = 40
        }else if fontSize == 16 {
            lineHeight = 36
        }else if fontSize == 14 {
            lineHeight = 32
        }
        return lineHeight
    }
    
}