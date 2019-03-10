//
//  OpenSourceViewController.swift
//  Project01
//
//  Created by 박종현 on 08/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class OpenSourceViewController: UIViewController {

	@IBOutlet weak var vNavigationBar: UIView!
	@IBOutlet weak var vContent: UIView!
	
	var webviewVC: BaseWebViewController?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// 375화면 기준으로 스케일 적용
		let scale: CGFloat = DEF_WIDTH_375_SCALE
		view.transform = view.transform.scaledBy(x: scale, y: scale)
		
		// 그림자 처리
		vNavigationBar.layer.shadowColor = UIColor(hex: 0xAAAAAA).cgColor
		vNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 7)
		vNavigationBar.layer.shadowOpacity = 0.16

		let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
		webviewVC = storyboard?.instantiateViewController(withIdentifier: "BaseWebViewController") as? BaseWebViewController
		webviewVC!.webviewType = .kWebviewTypeView
		webviewVC!.strUrlTrigger = (URL(fileURLWithPath: Bundle.main.path(forResource: "OpenSourceLicense", ofType: "html", inDirectory: "www") ?? "")).absoluteString
		vContent!.addSubview(webviewVC!.view)
		addChild(webviewVC!)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let frame = vContent?.bounds
		webviewVC!.view.frame = frame!
	}
    
    @IBAction func backBtnClicked(_ sender: Any) {
		
		// 뒤로 갈수 있는 상태면 history back
		if let webView = webviewVC?.webView {
			if webView.canGoBack == true {
				// web에서 히스토리백 처리 맡길려고...
				webView.goBack()
				return
			}
		}
		
		self.navigationController?.popViewController(animated: true)
    }
}
