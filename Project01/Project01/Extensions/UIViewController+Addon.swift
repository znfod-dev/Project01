//
//  UIViewController+Addon.swift
//  Project01
//
//  Created by 박종현 on 13/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension UIViewController {
    static func GetController(storyboard:String, identifier:String) -> UIViewController{
        let storyboard:UIStoryboard = UIStoryboard.init(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    func GetController(storyboard:String) -> UIViewController {
        let storyboard:UIStoryboard = UIStoryboard.init(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return viewController
    }
}
