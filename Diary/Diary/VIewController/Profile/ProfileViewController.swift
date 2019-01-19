//
//  ViewController.swift
//  Diary
//
//  Created by Byunsangjin on 02/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import Hero
import RealmSwift

class ProfileViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var modiButton: UIButton!
    
    
    
    
    // MARK:- Variables
    var user = User()
    var isModify: Bool? = false // 수정을 눌렀는지 안눌렀는지 확인하는 메소드
    
    
    
    // MARK:- Constants
    let userInfoTitle = ["이름", "주소", "전화", "휴대폰", "이메일", "직장 주소", "직장 전화", "직장 이메일", "", "Best Movie", "Best Book", "Best Music"]
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        self.initSet()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        DBManager.shared.updateUserDB(user: self.user) // 유저 정보 업데이트
        
        // 뷰를 불러오면 다시 처음 세팅으로 초기화
        self.modiButton.setTitle("수정", for: .normal)
        self.isModify = false
        self.tableView.reloadData()
    }
    
    
    
    // 초기 화면 설정
    func initSet() {
        // statusBar 색상 적용
        self.statusBarSet(view: self.view)
        
        self.tableView.separatorStyle = .none // 테이블 뷰 선 안보이게 하기
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap))) // tap 제스쳐 추가
        
        self.user = DBManager.shared.selectUserDB() // DB에서 User 불러오기
    }
    
    
    
    // 탭 했을 때 키보드 사라지게 하는 메소드
    @objc func tap() {
        self.view.endEditing(true)
    }
    
    
    
    
    // MARK:- Actions
    @IBAction func modiBtnPressed(_ sender: Any) {
        if self.modiButton.titleLabel?.text == "수정"{ // 수정을 클릭했을 때
            self.modiButton.setTitle("확인", for: .normal)
        } else { // 확인을 클릭했을 때
            self.tableView.endEditing(true)
            self.modiButton.setTitle("수정", for: .normal)
            DBManager.shared.updateUserDB(user: self.user)
        }
        
        self.isModify = !self.isModify!
        self.tableView.reloadData()
    }
}



// MARK:- Extension
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoTitle.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        let title = self.userInfoTitle[indexPath.row]
        
        // 타이틀이 없는 셀은 텍스트 필드 없앤다
        if title.isEmpty { cell.textField.isHidden = true }
        
        cell.title.text = title
        
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        self.userToTextfield(textField: cell.textField, user: self.user)
        
        if self.isModify == true { // 수정을 클릭했을 때
            cell.textField.isEnabled = true
        } else {
            cell.textField.isEnabled = false
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    // textFiled 텍스트를 user에 대입
    func textFieldToUser(textField: UITextField, user: User) {
        switch textField.tag {
            case 0: self.user.name = textField.text
            case 1: self.user.address = textField.text
            case 2: self.user.phone = textField.text
            case 3: self.user.mobile = textField.text
            case 4: self.user.email = textField.text
            case 5: self.user.workAddress = textField.text
            case 6: self.user.workPhone = textField.text
            case 7: self.user.workEmail = textField.text
            case 9: self.user.favoriteMovie = textField.text
            case 10: self.user.favoriteBook = textField.text
            case 11: self.user.favoriteMusic = textField.text
            default: ()
        }
    }
    
    
    
    // user데이터를 textField에 대입
    func userToTextfield(textField: UITextField, user: User) {
        switch textField.tag {
            case 0: textField.text = self.user.name
            case 1: textField.text = self.user.address
            case 2: textField.text = self.user.phone
            case 3: textField.text = self.user.mobile
            case 4: textField.text = self.user.email
            case 5: textField.text = self.user.workAddress
            case 6: textField.text = self.user.workPhone
            case 7: textField.text = self.user.workEmail
            case 9: textField.text = self.user.favoriteMovie
            case 10: textField.text = self.user.favoriteBook
            case 11: textField.text = self.user.favoriteMusic
            default: ()
        }
    }
}



extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldToUser(textField: textField, user: self.user)
    }
}
