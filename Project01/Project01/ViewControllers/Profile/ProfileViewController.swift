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
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
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
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)

        // 앱 최초 실행인지 체크
        if isFirstAppRun == true {
            btnBack.isHidden = true
            btnClose.isHidden = false
        }
        else {
            btnBack.isHidden = false
            btnClose.isHidden = true
        }
        
        self.profile = DBManager.sharedInstance.selectProfile()
        
        self.setTableSetting()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // sama73 : 뒤로가기 버큰 액션
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // sama73 : 닫기 버큰 액션
    @IBAction func closeBtnClicked(_ sender: Any) {
        let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController")
        UIApplication.shared.keyWindow?.rootViewController = sideMenuController
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text!
        let tag = textField.tag
        if tag == Profile.name.section() {
            self.profile.name = text
        }else if tag == Profile.surname.section() {
            self.profile.surname = text
        }else if tag == Profile.phone.section() {
            self.profile.phone = text
        }else if tag == Profile.mobile.section() {
            self.profile.mobile = text
        }else if tag == Profile.email.section() {
            self.profile.email = text
        }else if tag == Profile.workPhone.section() {
            self.profile.workPhone = text
        }else if tag == Profile.workEmail.section() {
            self.profile.workEmail = text
        }else {
            
        }
        DBManager.sharedInstance.updateProfile(profile: self.profile)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!
        let tag = textField.tag
        if tag == Profile.name.section() {
            surnameTextField.becomeFirstResponder()
        }else if tag == Profile.surname.section() {
            addressTextView.becomeFirstResponder()
        }else if tag == Profile.phone.section() {
            mobileTextField.becomeFirstResponder()
        }else if tag == Profile.mobile.section() {
            emailTextField.becomeFirstResponder()
        }else if tag == Profile.email.section() {
            workaddressTextView.becomeFirstResponder()
        }else if tag == Profile.workPhone.section() {
            workemailTextField.becomeFirstResponder()
        }else if tag == Profile.workEmail.section() {
            favouritefilmTextView.becomeFirstResponder()
        }else {
            
        }
        DBManager.sharedInstance.updateProfile(profile: self.profile)
        
        return true
        
    }
}
