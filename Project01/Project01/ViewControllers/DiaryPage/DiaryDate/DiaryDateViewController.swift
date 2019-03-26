//
//  DiaryDateViewController.swift
//  Project01
//
//  Created by 박종현 on 20/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryDateViewController: UIViewController, UITextViewDelegate {
    
    var diary:ModelDiary!
    var date:Date!
    
    var editMode = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var submitClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yy년 MM월 dd일"
        
        self.dateLabel.text = dateFormatter.string(from: self.date)
        self.updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func updateView() {
        DispatchQueue.main.async {
            if let temp = self.diary {
                print("diary 존재")
                // 다이어리가 존재할때
                if self.editMode == true {
                    print("수정모드")
                    // 수정모드
                    // 수정버튼 비 활성화
                    self.editBtn.isHidden = true
                    self.submitBtn.isHidden = false
                    self.cancelBtn.isHidden = false
                    
                    self.textView.isUserInteractionEnabled = true
                    self.textView.backgroundColor = UIColor.init(red: 243, green: 243, blue: 243)
                }else {
                    print("비수정모드")
                    // 비 수정모드
                    // 수정버튼 활성화
                    self.editBtn.isHidden = false
                    self.submitBtn.isHidden = true
                    self.cancelBtn.isHidden = true
                    self.textView.isUserInteractionEnabled = false
                    self.textView.backgroundColor = UIColor.clear
                }
                self.textView.text = temp.diary
            }else {
                print("diary 존재 안함")
                // 다이어리가 존재하지 않을 때
                self.editBtn.isHidden = true
                self.submitBtn.isHidden = false
                self.cancelBtn.isHidden = false
            }
        }
    }
    
    
    
    @IBAction func editBtnClicked(_ sender: Any) {
        print("editBtnClicked")
        self.editMode = !self.editMode
        self.updateView()
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("submitBtnClicked")
        if self.submitClick != nil {
            self.submitClick!()
        }
        
        let diaryText = self.textView.text
        
        if let _ = self.diary {
            // 다이어리가 있을때
            print("diary가 있을때")
        }else {
            // 다이어리가 없을때
            print("diary가 없을때")
            if let _ = diaryText {
                
            }else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            print("diary 생성")
            self.diary = ModelDiary.init()
            self.diary.id = self.date.GetId()
            self.diary.date = self.date
        }
        // 다이어리가 있을때
        self.diary.diary = diaryText!
        
        print("diary 넣기")
        DBManager.shared.insertDiary(diary: self.diary)
        
        
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        print("cancelBtnClicked")
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK:- Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: kbSize.height, right: 0)
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
    }
    
    @objc func dismissKeyboard() {
        print("dismissKeyboard")
        self.view.endEditing(true)
        
        if let _ = self.diary {
            // 다이어리가 있을때
            
            if self.editMode == false {
                self.dismiss(animated: false, completion: nil)
            }
            
        }
    }
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        let size = self.textView.bounds.size
        let newSize = self.textView.sizeThatFits(CGSize(width: size.width, height: 150))
        let estimatedHeight = newSize.height > 16 ? newSize.height : 16
        print("estimatedHeight : \(estimatedHeight)")
        
        let height = self.textView.frame.height
        if height > 150 {
            if estimatedHeight < 150 {
                print("isScrollEnabled = false")
                self.textView.isScrollEnabled = false
            }else {
                print("isScrollEnabled = true")
                self.textView.isScrollEnabled = true
            }
        }else {
            print("isScrollEnabled = false")
            self.textView.isScrollEnabled = false
        }
    }
    
}
