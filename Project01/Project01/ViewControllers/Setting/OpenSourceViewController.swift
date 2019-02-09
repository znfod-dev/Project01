//
//  OpenSourceViewController.swift
//  Project01
//
//  Created by 박종현 on 08/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class OpenSourceViewController: UIViewController {

	@IBOutlet weak var vContent: UIView?
	var webviewVC: BaseWebViewController?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
