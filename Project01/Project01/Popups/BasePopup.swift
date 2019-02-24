//
//  BasePopup.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 4..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class BasePopup: UIViewController {

    // Dimmed Alert 팝업 VC 매니져
    static var gPopupVCManager: UIViewController?

    var isLandscape = false
    var isNotDimmedTouch = false
    var closeClick: (() -> Void)?
    // 팀드 뷰
    @IBOutlet weak var vDimmed: UIView!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)

		// 뷰영역을 미리 스케일에 적용 시켜준다.
		var bounds: CGRect = view.bounds
		let width: CGFloat = bounds.size.width
		if width == DEF_SCREEN_WIDTH {
			let scale: CGFloat = DEF_SCREEN_375_WIDTH / width
			bounds.size.width *= scale
			bounds.size.height *= scale
			
			view.bounds = bounds
		}
		
        self.vDimmed.isAccessibilityElement = true
        
        view.backgroundColor = UIColor.clear
        
        // 딤드뷰 클릭시 팝업 닫아 주기
        if isNotDimmedTouch == false {
            //    self.view.userInteractionEnabled = YES;
            vDimmed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BasePopup.onCloseClick(_:))))
        }
        
        // 적용된 뷰를 모달 처리 함
        view.accessibilityViewIsModal = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func addActionCloseClick(_ CloseClick: @escaping () -> Void) {
        
        closeClick = CloseClick
    }
    
    func initGUI() {
    }
    
    func removeFromParentVC() {
        view.removeFromSuperview()
        removeFromParent()
        
        // 팝업 마지막 딤드뷰를 보여준다.
        let popup = BasePopup.gPopupVCManager!.children.last as? BasePopup
        if CommonUtil.isEmpty(popup) == false {
            popup!.vDimmed.isHidden = false
        }
    }
    
    // 최근검색 높이 제조정
    func showAnimationSchedule() {
    }
    
    // MARK: - UIButton Action
    @IBAction func onCloseClick(_ sender: Any) {
        
        callbackWithClose()
    }
    
    // MARK: - Callback Event
    func callbackWithClose() {
        
        if let closeAction = closeClick {
            closeAction()
        }
        
        removeFromParentVC()
    }
    
    // MARK: - Class Method
    static func addChildVC(_ childController: BasePopup?) {
        
        guard let appDelegate = AppDelegate.sharedAppDelegate() else {
            return
        }
        
        // Dimmed Alert 팝업 VC 매니져 생성이 안되어 있으면 새로 생성해준다.
        if BasePopup.gPopupVCManager == nil {
            BasePopup.gPopupVCManager = UIViewController()
        }
		
		if let childC = childController {
			appDelegate.window?.addSubview(childC.view)
			BasePopup.gPopupVCManager!.addChild(childC)
		}
		
		// 1개 이하일 경우 더이상 처리하지 않는다.
		if BasePopup.gPopupVCManager!.children.count <= 1{
			return
		}
		
		// 로딩 뷰를 찾는다.
		var loadPopup: LoaddingPopup? = nil
		for popup in BasePopup.gPopupVCManager!.children {
			if popup is LoaddingPopup {
				loadPopup = popup as? LoaddingPopup
			}
		}
		
		// 가장 위로 옮긴다.
		if let popup = loadPopup {
			popup.view.removeFromSuperview()
			popup.removeFromParent()
			
			appDelegate.window?.addSubview(popup.view)
			BasePopup.gPopupVCManager!.addChild(popup)
		}
		
        // 가장 위에 있는 딤드뷰만 활성화 시킨다.
        let childViewControllers:[UIViewController] = BasePopup.gPopupVCManager!.children
        for i in 0..<childViewControllers.count {
            let popup: BasePopup? = childViewControllers[i] as? BasePopup
            if i == childViewControllers.count - 1 {
                popup?.vDimmed.isHidden = false
            } else {
                popup?.vDimmed.isHidden = true
            }
        }
    }
}
