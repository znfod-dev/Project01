//
//  ProfileViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 앱 최초 실행인지 체크
    var isFirstAppRun: Bool = false
    
    var nameTextField: UITextField!
    var surnameTextField: UITextField!
    var addressTextView:UITextView!
    var phoneTextField: UITextField!
    var mobileTextField: UITextField!
    var emailTextField: UITextField!
    
    var workaddressTextView:UITextView!
    var workphoneTextField: UITextField!
    var workemailTextField: UITextField!
    
    var favouritefilmTextView:UITextView!
    var favouritebookTextView:UITextView!
    var favouritemusicTextView:UITextView!
    
    var profile:ModelProfile!
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        print("Profile viewdidload")
        
        self.profile = DBManager.sharedInstance.selectProfile()
        
        self.setTableSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        if isFirstAppRun == true {
            // 프로필 화면 보여주기
            if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
                let mainVC:UIViewController = storyboard.instantiateInitialViewController()!
                self.present(mainVC)
            }
        }else {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    func setTableSetting() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = FontManager.shared.getLineHeight()
    }
    
    override func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeLeftGesture(recognizer)
        let storyboard:UIStoryboard = self.storyboard!
        
        let viewController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "PlanListNavigation") as! UINavigationController
        
        self.present(viewController)
    }
    override func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        super.handleSwipeRightGesture(recognizer)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: 200))
        let estimatedHeight = newSize.height > FontManager.shared.getLineHeight() ? newSize.height : FontManager.shared.getLineHeight()
        
        textView.frame = CGRect.init(x: 5, y: 0, width: textView.frame.width, height: estimatedHeight)
        
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let tag = textView.tag
        if tag == Profile.address.section() {
            self.profile.address = textView.text
        }else if tag == Profile.workAddress.section() {
            self.profile.workAddress = textView.text
        }else if tag == Profile.favouriteFilm.section() {
            self.profile.favouriteFilm = textView.text
        }else if tag == Profile.favouriteBook.section() {
            self.profile.favouriteBook = textView.text
        }else if tag == Profile.favouriteMusic.section() {
            self.profile.favouriteMusic = textView.text
        }else {
            
        }
        DBManager.sharedInstance.updateProfile(profile: self.profile)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!
        let tag = textField.tag
        if tag == Profile.name.section() {
            self.profile.name = text
            surnameTextField.becomeFirstResponder()
        }else if tag == Profile.surname.section() {
            self.profile.surname = text
            addressTextView.becomeFirstResponder()
        }else if tag == Profile.phone.section() {
            self.profile.phone = text
            mobileTextField.becomeFirstResponder()
        }else if tag == Profile.mobile.section() {
            self.profile.mobile = text
            emailTextField.becomeFirstResponder()
        }else if tag == Profile.email.section() {
            self.profile.email = text
            workaddressTextView.becomeFirstResponder()
        }else if tag == Profile.workPhone.section() {
            self.profile.workPhone = text
            workemailTextField.becomeFirstResponder()
        }else if tag == Profile.workEmail.section() {
            self.profile.workEmail = text
            favouritefilmTextView.becomeFirstResponder()
        }else {
            
        }
        DBManager.sharedInstance.updateProfile(profile: self.profile)
        
        return true
        
    }
    
    
    
    
}
