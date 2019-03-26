//
//  TodoListAddPopup.swift
//  Project01
//
//  Created by 김삼현 on 25/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class TodoListAddPopup: BasePopup {

	@IBOutlet private weak var lbTitle: UILabel!
	@IBOutlet private weak var tfMessage: UITextField!
	@IBOutlet private weak var btnConfirm: UIButton!
	@IBOutlet private weak var btnCancel: UIButton!
	@IBOutlet weak var vContentViewHeightConstraint: NSLayoutConstraint!
	private var confirmClick: ((_ message: String?) -> Void)?
	private var cancelClick: (() -> Void)?

    override func viewDidLoad() {
		// 딤드뷰 클릭시 팝업 닫아 주는 기능 막기
		self.isNotDimmedTouch = true;

        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		vContentViewHeightConstraint.constant = self.view.bounds.height
		btnConfirm.layer.cornerRadius = 20.0
		btnCancel.layer.cornerRadius = 20.0
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	// 일반 메세지
	func setConfig(_ dicConfig: [String: Any]?) {
		// 딤드 알파 애니
		initGUI()
		
		if let dicConfig = dicConfig {
			if dicConfig.keys.contains("TITLE") {
				lbTitle.text = dicConfig["TITLE"] as? String
			}
			
			if dicConfig.keys.contains("MESSAGE") {
				tfMessage.text = dicConfig["MESSAGE"] as? String
				// 텍스트 전체 선택
				tfMessage.selectAll(nil)
			}
			
			if dicConfig.keys.contains("KEYBOARD_TYPE") {
				let keyboardType: UIKeyboardType = dicConfig["KEYBOARD_TYPE"] as! UIKeyboardType
				tfMessage.keyboardType = keyboardType
			}
			
			tfMessage.becomeFirstResponder()
		}
	}
	
	func addActionConfirmClick(handler ConfirmClick: @escaping (_ message: String?) -> Void) {
		
		confirmClick = ConfirmClick
	}
	
	func addActionCancelClick(handler CancelClick: @escaping () -> Void) {

		cancelClick = CancelClick
	}
	
	// MARK: - UIButton Action
	// 확인 버튼
	@IBAction func onConfirmClick(_ sender: Any) {
		callbackWithConfirm()
	}
	
	// 취소 버튼
	@IBAction func onCancelClick(_ sender: Any) {
		callbackWithCancel()
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
			
			vContentViewHeightConstraint.constant = self.view.bounds.height - kbSizeHeight
		}
	}
	
	// 언포커싱 되었을때 스크롤뷰 마진값 해제
	@objc func keyboardWillHide(_ notification: NSNotification) {
		print("keyboardWillHide")
		
		vContentViewHeightConstraint.constant = self.view.bounds.height
	}
	
	// MARK: - Callback Event
	func callbackWithConfirm() {
		
		if let confirmAction = confirmClick {
			confirmAction(tfMessage!.text)
		}
		
		removeFromParentVC()
	}
	
	func callbackWithCancel() {
		
		if let cancelAction = cancelClick {
			cancelAction()
		}
		
		removeFromParentVC()
	}
	
	// MARK: - Class Method
	/**
	message : 메세지
	*/
	static func messagePopup(dicConfig: [String: Any]?) -> TodoListAddPopup {
		
		let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
		let promptMessageVC = storyboard?.instantiateViewController(withIdentifier: "TodoListAddPopup") as? TodoListAddPopup
		// 팝업으로 떳을때
		promptMessageVC!.providesPresentationContextTransitionStyle = true
		promptMessageVC!.definesPresentationContext = true
		promptMessageVC!.modalPresentationStyle = .overFullScreen
		
		BasePopup.addChildVC(promptMessageVC)
		
		// 데이터 세팅
		promptMessageVC!.setConfig(dicConfig)
		
		return promptMessageVC!
	}
}

