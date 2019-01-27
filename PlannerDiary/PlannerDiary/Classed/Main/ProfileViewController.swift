//
//  ProfileViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2018. 12. 31..
//  Copyright © 2018년 sama73. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class ProfileViewController: UIViewController {
	
	// 다이어리 오너 정보 로드 유무
	var isOwnerInfoLoad: Bool = false
    
    // UITextField, UITextView포커스 매니저
	var focusManager : FocusManager?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfName: UnderlineTextField!
	@IBOutlet weak var tfSurName: UnderlineTextField!
	@IBOutlet weak var tfAddress: UnderlineTextField!
	@IBOutlet weak var tfPhone: UnderlineTextField!
	@IBOutlet weak var tfMobile: UnderlineTextField!
	@IBOutlet weak var tfEmail: UnderlineTextField!
	
	@IBOutlet weak var tfWorkAddress: UnderlineTextField!
	@IBOutlet weak var tfWorkPhone: UnderlineTextField!
	@IBOutlet weak var tfWorkEmail: UnderlineTextField!
	
	@IBOutlet weak var tfFavouriteFilm: UnderlineTextField!
	@IBOutlet weak var tfFavouriteBook: UnderlineTextField!
	@IBOutlet weak var tfFavouriteMusic: UnderlineTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)

        // Do any additional setup after loading the view.		
        self.focusManager = FocusManager()
		self.focusManager?.addItem(item: self.tfName)
		self.focusManager?.addItem(item: self.tfSurName)
		self.focusManager?.addItem(item: self.tfAddress)
		self.focusManager?.addItem(item: self.tfPhone)
		self.focusManager?.addItem(item: self.tfMobile)
		self.focusManager?.addItem(item: self.tfEmail)
		
		self.focusManager?.addItem(item: self.tfWorkAddress)
		self.focusManager?.addItem(item: self.tfWorkPhone)
		self.focusManager?.addItem(item: self.tfWorkEmail)
		
		self.focusManager?.addItem(item: self.tfFavouriteFilm)
		self.focusManager?.addItem(item: self.tfFavouriteBook)
		self.focusManager?.addItem(item: self.tfFavouriteMusic)
		
		self.focusManager?.focus(index: 0)
		
		// 프로필 DB로드
		profileDBLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillShow(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillHide(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self)

        super.viewWillDisappear(animated)
    }
	
	// 프로필 DB로드
	func profileDBLoad() {
		// 오너 정보 검색
		let sql = "SELECT * FROM OwnerInfo WHERE uid='1';"
		// SQL 결과
		let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
		let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
		// 검색 성공
		if resultCode == "0" {
			let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
			// 오너 정보가 없을때...
			if resultData.count == 0 {
				return
			}
			
			let ownerInfo: OwnerInfo = resultData.first as! OwnerInfo
			tfName.text = ownerInfo.name
			tfSurName.text = ownerInfo.surName
			tfAddress.text = ownerInfo.address
			tfPhone.text = ownerInfo.phone
			tfMobile.text = ownerInfo.mobile
			tfEmail.text = ownerInfo.email
			
			tfWorkAddress.text = ownerInfo.workAddress
			tfWorkPhone.text = ownerInfo.workPhone
			tfWorkEmail.text = ownerInfo.workEmail
			
			tfFavouriteFilm.text = ownerInfo.favouriteFilm
			tfFavouriteBook.text = ownerInfo.favouriteBook
			tfFavouriteMusic.text = ownerInfo.favouriteMusic
			
			// 다이어리 오너 정보 로드 유무
			self.isOwnerInfoLoad = true
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: - UIButton Action    
    // 프로필 저장
    @IBAction func onProfileSaveClick(_ sender: Any) {
        
		// UITextField, UITextView 포커스 제거
		self.view.window?.endEditing(true)

		// 필수 입력 사항 체크
		if tfName.text == "" {
			let popup = AlertMessagePopup.messagePopup(message: "Name을 입력해 주세요!")
			popup.addActionConfirmClick("확인", handler: {
				self.tfName.becomeFirstResponder()
			})
			return
		}

		if tfSurName.text == "" {
			let popup = AlertMessagePopup.messagePopup(message: "SurName을 입력해 주세요!")
			popup.addActionConfirmClick("확인", handler: {
				self.tfSurName.becomeFirstResponder()
			})
			return
		}
		
		if tfMobile.text == "" {
			let popup = AlertMessagePopup.messagePopup(message: "Mobile을 입력해 주세요!")
			popup.addActionConfirmClick("확인", handler: {
				self.tfMobile.becomeFirstResponder()
			})
			return
		}
		
		if tfEmail.text == "" {
			let popup = AlertMessagePopup.messagePopup(message: "Email을 입력해 주세요!")
			popup.addActionConfirmClick("확인", handler: {
				self.tfEmail.becomeFirstResponder()
			})
			return
		}
        
        // 다이어리 오너 정보 로드 유무
		if self.isOwnerInfoLoad == false {
            // 다이어리 소유자 정보 추가
            insertOwnerInfoTable()
		}
		else {
            // 다이어리 소유자 정보 추가
            updateOwnerInfoTable()
		}
		
        self.dismiss(animated: true, completion: nil)
    }
    
    // 닫기
    @IBAction func onCloseClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NotificationCenter
    // 인포커싱 되었을때 스크롤뷰 마진값 적용
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboardWillShow")
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            // iPhoneX 스타일 경우 마진을 34만큼 더준다.
            var gapOffsetY : CGFloat = 0.0
            if CommonUtil.isIphoneX == true {
                gapOffsetY = 34.0
            }
			// 키보드 높이
			let kbSizeHeight : CGFloat = keyboardRectangle.height - gapOffsetY
			
            // 스크롤바 키보드 높이 만큼 마진주기
            let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSizeHeight, right: 0)
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    // 언포커싱 되었을때 스크롤뷰 마진값 해제
    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("keyboardWillHide")
        
        // 스크롤바 마진 제거
        let contentInset: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    // MARK: - RealmDB SQL Excute
    // 다이어리 소유자 정보 추가
    func insertOwnerInfoTable() {
        // RelamDB INSERT문
        var sql = "INSERT INTO OwnerInfo(uid, "
        sql += "name, "
        sql += "surName, "
        sql += "address, "
        sql += "phone, "
        sql += "mobile, "
        sql += "email, "
        sql += "workAddress, "
        sql += "workPhone, "
        sql += "workEmail, "
        sql += "favouriteFilm, "
        sql += "favouriteBook, "
        sql += "favouriteMusic) VALUES('1', "
        sql += "'\(tfName.text!)', "
        sql += "'\(tfSurName.text!)', "
        sql += "'\(tfAddress.text!)', "
        sql += "'\(tfPhone.text!)', "
        sql += "'\(tfMobile.text!)', "
        sql += "'\(tfEmail.text!)', "
        sql += "'\(tfWorkAddress.text!)', "
        sql += "'\(tfWorkPhone.text!)', "
        sql += "'\(tfWorkEmail.text!)', "
        sql += "'\(tfFavouriteFilm.text!)', "
        sql += "'\(tfFavouriteBook.text!)', "
        sql += "'\(tfFavouriteMusic.text!)');"
        
        // SQL 결과
        DBManager.SQLExcute(sql: sql)
    }

    // 다이어리 소유자 정보 수정
    func updateOwnerInfoTable() {
        // RelamDB UPDATE문
        var sql = "UPDATE OwnerInfo SET "
        sql += "name='\(tfName.text!)', "
        sql += "surName='\(tfSurName.text!)', "
        sql += "address='\(tfAddress.text!)', "
        sql += "phone='\(tfPhone.text!)', "
        sql += "mobile='\(tfMobile.text!)', "
        sql += "email='\(tfEmail.text!)', "
        sql += "workAddress='\(tfWorkAddress.text!)', "
        sql += "workPhone='\(tfWorkPhone.text!)', "
        sql += "workEmail='\(tfWorkEmail.text!)', "
        sql += "favouriteFilm='\(tfFavouriteFilm.text!)', "
        sql += "favouriteBook='\(tfFavouriteBook.text!)', "
        sql += "favouriteMusic='\(tfFavouriteMusic.text!)' WHERE uid='1';"
        
        // SQL 결과
        DBManager.SQLExcute(sql: sql)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    // 언더라인 선택 색상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 언더라인 선택 색상 적용
        if textField is UnderlineTextField {
            focusManager?.focusTouch(item: textField)
        }
    }
    
    // 언더라인 비선택 생상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 언더라인 미선택 색상 적용
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        // 엔터키 눌렀을때 다음 컨트롤로 이동
        if let focusManager = self.focusManager {
            focusManager.focusNext()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 전화번호, 핸드폰 번호 체크
        if textField == tfPhone || textField == tfMobile || textField == tfWorkPhone {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 11
        }
        
        return true
    }
}
