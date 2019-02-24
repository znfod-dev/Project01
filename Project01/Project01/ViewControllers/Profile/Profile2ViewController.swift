//
//  Profile2ViewController.swift
//  Project01
//
//  Created by 박종현 on 23/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class Profile2ViewController: UIViewController, UINavigationControllerDelegate {
    
    // 모달인가?
    var isModal: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var profileImageBtn: UIButton!
    
    var profileImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        
        // 키보드 show hide 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @IBAction func profileImageBtnClicked(_ sender: Any) {
        print("profileImageBtnClicked")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
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
        let storyboard = UIStoryboard.init(name: "Utills", bundle: nil)
        
        let imageEditVC:ImageEditViewController = storyboard.instantiateViewController(withIdentifier: "ImageEdit") as! ImageEditViewController
        imageEditVC.image = selectedImage
        imageEditVC.delegate = self
        self.present(imageEditVC, animated: true, completion: nil)
        
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
        DispatchQueue.main.async {
            self.profileImageBtn.setImage(self.profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
    }
}


