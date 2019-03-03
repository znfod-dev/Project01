//
//  DiaryPageViewController.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryPageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
	
	@IBOutlet weak var btnMenu: UIButton!
	@IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var tableView: UITableView!
	
	// 메뉴 버튼 활성화
	var isMenuButtonShow = false
	
	// 부모VC
	var parentVC: PageController?

    var currentDate = Date()
    var diary = ModelDiary()
    var minimumDate = DBManager.sharedInstance.loadMinimumDateFromUD()
    var maximumDate = DBManager.sharedInstance.loadMaximumDateFromUD()
    
    var activeView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sama73 : 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        self.setTableSetting()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
		// 메뉴 버튼 활성화
		if isMenuButtonShow == true {
			btnMenu.isHidden = false
			btnBack.isHidden = true
		}
		else {
			btnMenu.isHidden = true
			btnBack.isHidden = false
		}
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.loadDiary()
    }
    
    func setTableSetting() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = FontManager.shared.getLineHeight()
    }
    
    // MARK:- UITextViewDelegate
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        activeView = textView
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        self.diary.diary = textView.text
        if self.diary.diary == "" {
            self.diary.diary = " "
        }
        DBManager.sharedInstance.updateDiary(diary: self.diary)
        self.tableView.reloadData()
    }
    
    // MARK:- Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: kbSize.height, right: 0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            var aRect:CGRect = self.view.frame
            aRect.size.height -= kbSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK:- Actions
	// 사이드 메뉴
	@IBAction func onMenuClick(_ sender: Any) {
		sideMenuController?.revealMenu()
	}
	
	// 뒤로
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Handle Swipe
    override func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("handleSwipeLeftGesture")
        
        if self.checkMaximumDate() {
            self.currentDate = Calendar.current.date(byAdding: .day, value: +1, to: self.currentDate)!
            self.loadDiary()
        } else {
			let popup = AlertMessagePopup.messagePopup(message: "마지막 페이지입니다.")
			popup.addActionConfirmClick("확인", handler: {
				
			})
        }
    }
    override func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("handleSwipeRightGesture")
        if self.checkMinimumDate() {
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)!
            self.loadDiary()
        } else {
			let popup = AlertMessagePopup.messagePopup(message: "첫 페이지입니다.")
			popup.addActionConfirmClick("확인", handler: {
				
			})
        }
    }
    // 최소 날짜 검사
    func checkMinimumDate() -> Bool {
        let updatePage = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.minimumDate)
        if Double(temp) < 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    // 최대 날짜 검사
    func checkMaximumDate() -> Bool {
        
        let updatePage = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.maximumDate)
        if Double(temp) > 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    
    // 다이어리 가져오기
    func loadDiary() {
        self.diary = DBManager.sharedInstance.selectDiary(date: currentDate)
        self.tableView.reloadData()
    }
    
    
}

extension DiaryPageViewController: UIScrollViewDelegate {
	
	// 스크롤 뷰에서 내용 스크롤을 시작할 시점을 대리인에게 알립니다.
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		print("scrollViewWillBeginDragging:")
		
	}
	
	// 드래그가 스크롤 뷰에서 끝났을 때 대리자에게 알립니다.
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		print("scrollViewDidEndDragging:willDecelerate:")
		
	}
	
	// (현재 못씀)
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		print("scrollViewDidEndScrollingAnimation")
		
	}
	
	// 스크롤뷰가 Touch-up 이벤트를 받아 스크롤 속도가 줄어들때 실행된다.
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		print("scrollViewWillBeginDecelerating")
		
	}
	
	// 스크롤 애니메이션의 감속 효과가 종료된 후에 실행된다.
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		// 타임 아웃 되었을때...
		if let parentVC = self.parentVC {
			parentVC.UserInteractionClear()
		}
	}
	
	// scrollView.scrollsToTop = YES 설정이 되어 있어야 아래 이벤트를 받을수 있다.
	// 스크롤뷰가 가장 위쪽으로 스크롤 되기 전에 실행된다. NO를 리턴할 경우 위쪽으로 스크롤되지 않도록 한다.
	//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
	//{
	//    NSLog(@"scrollViewShouldScrollToTop");
	//    return YES;
	//}
	
	// 스크롤뷰가 가장 위쪽으로 스크롤 된 후에 실행된다.
	//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
	//{
	//    NSLog(@"scrollViewDidScrollToTop");
	//}
	
	// 사용자가 콘텐츠 스크롤을 마쳤을 때 대리인에게 알립니다.
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		print("scrollViewWillEndDragging:withVelocity:targetContentOffset:")
		
	}
}
