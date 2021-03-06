//
//  AlertMessagePopup.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 4..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class AlertMessagePopup: BasePopup {

    @IBOutlet private weak var lbMessage: UILabel!
    @IBOutlet private weak var btnConfirm: UIButton!
	@IBOutlet private weak var btnConfirmWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var btnCancelWidthConstraint: NSLayoutConstraint!
    private var confirmClick: (() -> Void)?
    private var cancelClick: (() -> Void)?
    
    override func viewDidLoad() {
        
        // 딤드뷰 클릭시 팝업 닫아 주는 기능 막기
        self.isNotDimmedTouch = true;

        super.viewDidLoad()

        // Do any additional setup after loading the view.
		btnConfirm.layer.cornerRadius = 20.0
		btnCancel.layer.cornerRadius = 20.0
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
    func messagePopup(withMessage message: String?) {
        // 딤드 알파 애니
        initGUI()
        
        lbMessage.text = message
    }
    
    func addActionConfirmClick(_ actionWithTitle: String?, handler ConfirmClick: @escaping () -> Void) {
        
        btnConfirm.setTitle(actionWithTitle, for: .normal)
		
		btnConfirm.isHidden = false
        if cancelClick != nil {
			btnCancel.isHidden = false
			
			btnConfirmWidthConstraint.constant = 110.0
			btnCancelWidthConstraint.constant = 110.0
        }
        else {
			btnCancel.isHidden = true
			
            btnConfirmWidthConstraint.constant = 245.0
        }
        
        confirmClick = ConfirmClick
    }
    
    func addActionCancelClick(_ actionWithTitle: String?, handler CancelClick: @escaping () -> Void) {
        if CommonUtil.isEmpty(actionWithTitle as AnyObject) {
            return
        }
        
        btnCancel.setTitle(actionWithTitle, for: .normal)
		
		btnCancel.isHidden = false
        if confirmClick != nil {
			btnConfirm.isHidden = false
			
			btnConfirmWidthConstraint.constant = 110.0
			btnCancelWidthConstraint.constant = 110.0
        } else {
			btnConfirm.isHidden = true
			
            btnCancelWidthConstraint.constant = 245.0
        }
        
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

    // MARK: - Callback Event
    func callbackWithConfirm() {
        
        if let confirmAction = confirmClick {
            confirmAction()
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
    static func messagePopup(message: String?) -> AlertMessagePopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let MessagePopupVC = storyboard?.instantiateViewController(withIdentifier: "AlertMessagePopup") as? AlertMessagePopup
        // 팝업으로 떳을때
        MessagePopupVC!.providesPresentationContextTransitionStyle = true
        MessagePopupVC!.definesPresentationContext = true        
        MessagePopupVC!.modalPresentationStyle = .overFullScreen
        
        BasePopup.addChildVC(MessagePopupVC)
        
        // 데이터 세팅
        MessagePopupVC!.messagePopup(withMessage: message)
        
        return MessagePopupVC!
    }
}
