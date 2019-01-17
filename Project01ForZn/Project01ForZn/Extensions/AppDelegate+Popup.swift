//
//  AppDelegate+Popup.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    static func sharedAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func sharedNamedStroyBoard(storyboardName:String) -> UIStoryboard {
        return UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
    }

}
