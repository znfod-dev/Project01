//
//  Profile2ViewController.swift
//  Project01
//
//  Created by 박종현 on 23/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import CloudKit

class Profile2ViewController: UIViewController, UINavigationControllerDelegate {
    
    // 모달인가?
    var isModal: Bool = false
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var editCompleteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameDelBtn: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressDelBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneDelBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailDelBtn: UIButton!
    
    @IBOutlet weak var startBtn: UIButton!
    
    var profile:ModelProfile!
    
    var imagePicker: UIImagePickerController!
    var profileImage:UIImage!
    
    var editable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
       
        // 최초 실행
        if isModal == true {
            startBtn.isHidden = true
            backBtn.isHidden = true
            //menuBtn.isHidden = false
        } else {
            startBtn.isHidden = false
            backBtn.isHidden = false
            closeBtn.isHidden = true
        }
        editCompleteBtn.isHidden = true
        
        
        // 키보드 show hide 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.profile = DBManager.sharedInstance.selectProfile()
        self.updateTextField()
        
        /*
         Test
         */
        
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        
    }
    
    func updateTextField() {
        DispatchQueue.main.async {
         
            self.nameTextField.text = self.profile.name
            
            self.phoneTextField.text = self.profile.phone
            
            self.addressTextField.text = self.profile.address
            
            self.emailTextField.text = self.profile.email
            if self.editable == true {
                self.nameDelBtn.isHidden = false
                self.nameTextField.isUserInteractionEnabled = true
                self.phoneDelBtn.isHidden = false
                self.phoneTextField.isUserInteractionEnabled = true
                self.addressDelBtn.isHidden = false
                self.addressTextField.isUserInteractionEnabled = true
                self.emailDelBtn.isHidden = false
                self.emailTextField.isUserInteractionEnabled = true
                self.editCompleteBtn.isHidden = false
                self.editBtn.isHidden = true
            }else {
                self.nameDelBtn.isHidden = true
                self.nameTextField.isUserInteractionEnabled = false
                self.phoneDelBtn.isHidden = true
                self.phoneTextField.isUserInteractionEnabled = false
                self.addressDelBtn.isHidden = true
                self.addressTextField.isUserInteractionEnabled = false
                self.emailDelBtn.isHidden = true
                self.emailTextField.isUserInteractionEnabled = false
                
                self.editCompleteBtn.isHidden = true
                self.editBtn.isHidden = false
            }
        }
    }
    
    
    // MARK:- @IBAction
    @IBAction func profileImageBtnClicked(_ sender: Any) {
        print("profileImageBtnClicked")
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    // sama73 : 뒤로가기 버큰 액션
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // sama73 : 닫기 버큰 액션
    @IBAction func closeBtnClicked(_ sender: Any) {
        // 사이드 메뉴 모달 오픈
        if isModal == true {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
            // 최초 실행
        else {
            let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController")
            UIApplication.shared.keyWindow?.rootViewController = sideMenuController
        }
    }
    @IBAction func editCompleteBtnClicked(_ sender: Any) {
        if self.editable == true {
            self.editable = false
        }else {
            self.editable = true
        }
        self.profile.name = self.nameTextField.text!
        self.profile.address = self.addressTextField.text!
        self.profile.phone = self.phoneTextField.text!
        self.profile.email = self.emailTextField.text!
        
        self.updateTextField()
    }
    @IBAction func startBtnClicked(_ sender: Any) {
        let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController")
        UIApplication.shared.keyWindow?.rootViewController = sideMenuController
    }
    @IBAction func editBtnClicked(_ sender: Any) {
        if self.editable == true {
            self.editable = false
        }else {
            self.editable = true
        }
        self.updateTextField()
    }
    @IBAction func nameDelBtnClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.nameTextField.text = String()
        }
    }
    @IBAction func addressDelBtnClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.addressTextField.text = String()
        }
    }
    @IBAction func phoneDelBtnClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.phoneTextField.text = String()
        }
    }
    @IBAction func emailDelBtnClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.emailTextField.text = String()
        }
    }
    
    // MARK:- Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: kbSize.height-20, right: 0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect:CGRect = self.view.frame
            aRect.size.height -= kbSize.height
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
extension Profile2ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            
            return
        }
        
        self.setProtocolImage(image: selectedImage)
        /*
        let storyboard = UIStoryboard.init(name: "Utills", bundle: nil)
        
        let imageEditVC:ImageEditViewController = storyboard.instantiateViewController(withIdentifier: "ImageEdit") as! ImageEditViewController
        imageEditVC.image = selectedImage
        imageEditVC.delegate = self
        self.present(imageEditVC, animated: true, completion: nil)
        */
        /*
        DispatchQueue.main.async {
            self.profileImageBtn.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        */
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image:UIImage) {
        // default NSFileManager 객체에 대한 참조체 얻기
        let filemgr = FileManager.default
        // *객체 참조체를 얻으면 파일과 디렉터리에 대한 작업 수행 가능
        
        
        // 현재 작업 디렉터리 확인
        let currentFilepath = filemgr.currentDirectoryPath
        
        // Documents 디렉터리 확인
        let dirpaths = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)
        let docsDir = dirpaths[0] as String
        //    * 위 코드를 실행하면 Documents 디렉터리 경로는 docsDir에 할당
        
        // 임시 디렉터리 확인
        let tmpDir = NSTemporaryDirectory()
    }
    
    
}

extension Profile2ViewController: ImageEditDelegate {
    func setProtocolImage(image: UIImage) {
        print("Profile2ViewController: ImageEditDelegate")
        self.profileImage = image
        
        let newRecord:CKRecord = CKRecord(recordType: "ImageRecord")

        DispatchQueue.main.async {
            self.profileImageBtn.setImage(self.profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
            
        }
    }
}


