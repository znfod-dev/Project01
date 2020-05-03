//
//  BaseViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeRightGesture(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLeftGesture(_:)))
        
        // let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeTopGesture(_:)))
        // let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeBottomGesture(_:)))
        
        swipeRight.direction = .right
        swipeLeft.direction = .left
        //swipeUp.direction = .up
        //swipeDown.direction = .down
        self.view.gestureRecognizers = [swipeLeft, swipeRight]
        //self.view.gestureRecognizers = [swipeUp, swipeDown, swipeLeft, swipeRight]
        
    }
    
    func dismiss() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    func presentFromTop(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func present(_ viewControllerToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    @objc func handleSwipeTopGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is top")
    }
    @objc func handleSwipeBottomGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is bottom")
    }
    @objc func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is right")
    }
    @objc func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is left")
    }
    
    func addLongPressGesture() {
        print("addLongPressGesture")
        let longPressLeft = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressLeftGesture(_:)))
        let longPressRight = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressRightGesture(_:)))
        longPressRight.allowableMovement = 10
        longPressLeft.allowableMovement = 50
        
        let leftAreaFrame = CGRect.init(x: 0, y: 0, width: 40, height: self.view.frame.height)
        let rightAreaFrame = CGRect.init(x: self.view.frame.width-40, y: 0, width: 40, height: self.view.frame.height)
        
        let longPressLeftArea = UIView(frame: leftAreaFrame)
        let longPressRightArea = UIView(frame: rightAreaFrame)
        
        longPressLeftArea.addGestureRecognizer(longPressLeft)
        longPressRightArea.addGestureRecognizer(longPressRight)
        
        self.view.addSubview(longPressLeftArea)
        self.view.addSubview(longPressRightArea)
        
    }
    @objc func handleLongPressRightGesture(_ recognizer: UILongPressGestureRecognizer) {
        //print("handleLongClickRightGesture")
        if recognizer.state == .began {
            //print("handleLongClickRightGesture began")
        }else if recognizer.state == .ended{
            //print("handleLongClickRightGesture ended")
        }else  if recognizer.state == .recognized {
            //print("handleLongClickRightGesture recognized")
        }else if recognizer.state == .changed {
            //print("handleLongClickRightGesture changed")
        }else if recognizer.state == .cancelled {
            //print("handleLongClickRightGesture cancelled")
        }else if recognizer.state == .failed {
            //print("handleLongClickRightGesture failed")
        }else if recognizer.state == .possible {
            //print("handleLongClickRightGesture possible")
        }
    }
    @objc func handleLongPressLeftGesture(_ recognizer: UILongPressGestureRecognizer) {
        //print("handleLongClickLeftGesture")
        if recognizer.state == .began {
            //print("handleLongClickLeftGesture began")
        }else if recognizer.state == .ended{
            //print("handleLongClickLeftGesture ended")
        }else  if recognizer.state == .recognized {
            //print("handleLongClickLeftGesture recognized")
        }else if recognizer.state == .changed {
            //print("handleLongClickRightGesture changed")
        }else if recognizer.state == .cancelled {
            //print("handleLongClickRightGesture cancelled")
        }else if recognizer.state == .failed {
            //print("handleLongClickRightGesture failed")
        }else if recognizer.state == .possible {
            //print("handleLongClickRightGesture possible")
        }
    }
    
    func showAlert(title:String, cancelTitle:String, cancelHandler: ((UIAlertAction) -> Void)? = nil!) {
        self.showAlert(title: title, message: nil, submitTitle: nil, submitHandler: nil, cancelTitle: cancelTitle, cancelHandler: cancelHandler)
    }
    func showAlert(title:String, message:String, submitTitle:String, cancelTitle:String) {
        self.showAlert(title: title, message: message, submitTitle: submitTitle, submitHandler: nil, cancelTitle: cancelTitle, cancelHandler: nil)
    }
    func showAlert(title:String, message:String!, submitTitle:String!, submitHandler: ((UIAlertAction) -> Void)? = nil!, cancelTitle:String!, cancelHandler: ((UIAlertAction) -> Void)? = nil!) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if let submitText = submitTitle {
            if let submitHandle = submitHandler {
                alert.addAction(UIAlertAction.init(title: submitText, style: .default, handler: submitHandle))
            }else {
                alert.addAction(UIAlertAction.init(title: submitText, style: .default, handler: nil))
            }
        }
        if let cancelText = cancelTitle {
            if let cancelHandle = cancelHandler {
                alert.addAction(UIAlertAction.init(title: cancelText, style: .cancel, handler: cancelHandle))
            }else {
                alert.addAction(UIAlertAction.init(title: cancelText, style: .cancel, handler: nil))
            }
        }
        self.present(alert, animated: true, completion: nil)
    }

}
