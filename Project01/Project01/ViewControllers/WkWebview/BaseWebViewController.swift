//
//  BaseWebViewController.swift
//  hello
//
//  Created by sama73 on 2019. 1. 24..
//  Copyright © 2019년 sama73. All rights reserved.
//
/** WKWebView 화면
 * WKWebKit framework
 - WKBackForwardList - 웹뷰에서 방문했던 웹 페이지 리스트
 - WKBackFowardListItem - 웹뷰 back-forward 리스트에 각 웹 페이지
 - WKFrameInfo - 웹 페이지에서 frame에 관한 정보를 포함
 - WKNavigation - 웹 페이지 로딩 과정을 추적하는 정보를 포함
 - WKNavigationAction - 웹 페이지 navigation을 유발하는 Action에 관한 정보를 포함
 - WKNavigationRespoonse - navigation 응답 값을 포함
 - WKPreferences - 웹뷰의 설정값을 캡슐화
 - WKProcessPool - 웹 컨텐츠 프로세스들의 pool
 - WKUserController - 자바스크립트로 메시지를 보내거나 웹뷰에 user script를 삽입
 - WKScriptMessage - 웹 페이지로 보낼 메시지의 정보를 포함
 - WKUserScript - 웹 페이지에 삽입할 스크립트
 - WKWebViewConfiguration - 웹 뷰를 초기화할 property 들의 collection
 - WKWindowFeatures - 새로운 웹 뷰를 요청할 때, 윈도우에 포함할 값들
 
 *Protocols
 - WKNavigationDelegate - main/sub frame load 정책과 main frame navigation 과정을 추적하는 메소드를 제공
 - WKScriptMessageHandler - 웹페이지에 동작하는 자바스크립트 메시지를 받는 메소드 제공
 - WKUIDelegate - 웹 페이지 상에서 native UI를 표현하는 메소드를 제공
 */

import UIKit
import WebKit


// Webview Type
enum eWebviewType : Int {
    case kWebviewTypeNone = 0x00
    case kWebviewTypeView = 0x01 // 웹뷰를 뷰에 붙이는 타입
    case kWebviewTypeBrowser = 0x02 // 웹뷰를 브라우져팝업에 붙이는 타입
    case kWebviewTypeLayer = 0x04 // 웹뷰를 레이어팝업에 붙이는 타입
}

// Webview Flag
enum eWebviewFlag : Int {
    case kWebviewFlagNone = 0
    case kWebviewFlagHeaderNotShow = 0x01 // 웹뷰 네비게이션 웹뷰 안보이게
    case kWebviewFlagPOSTRequest = 0x02 // POST방식으로 전송
    case kWebviewFlagTransparent = 0x04 // WkWebview 투명하게 처리
    case kWebviewFlagNotAnimation = 0x10 // 닫을때 애니메이션 없애기
    case kWebviewFlagExternal = 0x20 // 외부 경로 처리
    case kWebviewFlagShowMagicBoardingPass = 0x40 // 매직보딩패스 버튼 활성화
}

// 프로토콜 정의
@objc protocol WkWebViewControllerDelegate: NSObjectProtocol {
    // 필수적으로 들어가야만 되는 델리게이트
    // 선택적으로 들어가는 델리게이트
    // 웹뷰 닫기 이벤트
    @objc optional func webViewDidClose(withJsondata jsondata: String?)
    
    // 웹 타이틀
    @objc optional func webView(withTitle title: String?)
    
    // 웹 네비게이션바 Show/Hide
    @objc optional func webViewShowWith(on: Bool)
}


// BaseWebViewController 코드
class BaseWebViewController: UIViewController {

    // 네비 타이틀
    var strTitleTrigger = ""
    // 웹뷰 url
    var strUrlTrigger = ""
    // HTML tag
    var strHTMLTrigger = ""
    // 웹뷰 타입
    var webviewType: eWebviewType?
    // 웹뷰 플래그
    var webviewFlag: eWebviewFlag?
    // 이전 URL
    var old_request_url = ""
    
    // 프로토콜 연결
    weak var delegate: WkWebViewControllerDelegate?
    // 부모 VC
    var parentVC: UIViewController?
    
    // 최초 웹뷰인가?
    private var isRootWebView = false
    // 이전 리퀘스트
    private var old_request: NSMutableURLRequest?
    // 진입 시점 URL
    private var enter_url_path = ""
    
    private var configuration: WKWebViewConfiguration?
    
    // WKWebView
    var webView: WKWebView?
/*
    // WKWebView
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        
        var webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return webView
    }()
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if CommonUtil.isEmpty(webView) {
            isRootWebView = true
            
            configuration = WKWebViewConfiguration()
            if let configuration = self.configuration {
                // 여러 WKWebView 간의 쿠키 공유
                // 아시아나항공은 웹뷰 로그아웃 처리를 따로 하지 않아서 공유했을때 문제가 발생함.
                configuration.processPool = BaseWebViewController.sharedProcessPool()!
                
                configuration.preferences.javaScriptEnabled = true
                // allow facebook to open the login popup
                configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

                let contentController = WKUserContentController()
                /*
                // web -> native 호출할 함수명 List
                let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
                
                let wkUScript = WKUserScript(source: jScript,
                                             injectionTime: .atDocumentEnd,
                                             forMainFrameOnly: true)
                
                contentController.addUserScript(wkUScript)
                configuration.userContentController = contentController
                */

                // LongPress 기능 막기
                let jScript = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
                
                let wkUScript = WKUserScript(source: jScript,
                                             injectionTime: .atDocumentEnd,
                                             forMainFrameOnly: true)
                
                contentController.addUserScript(wkUScript)
                configuration.userContentController = contentController
                
                // WKWebView을 인스턴화
                self.webView = WKWebView(frame: view.frame, configuration: configuration)
            }
        }
        
        // Delegate설정
        if let webView = self.webView {
            webView.navigationDelegate = self
            webView.uiDelegate = self
            // 뒤로 앞으로 탐색 제스처 허용
            webView.allowsBackForwardNavigationGestures = true
            self.view = webView
            
//            webView.scrollView.isScrollEnabled = false
//            webView.scrollView.panGestureRecognizer.isEnabled = false
            webView.scrollView.bounces = false
            
            // 웹페이지에 <body style="background-color:transparent;"></body>
//            if webviewFlag!.rawValue & eWebviewFlag.kWebviewFlagTransparent.rawValue != 0 {
//                view.backgroundColor = UIColor.clear
//                webView.isOpaque = false
//                webView.backgroundColor = UIColor.clear
//                webView.scrollView.backgroundColor = UIColor.clear
//            }
			
            
            var strURL = strUrlTrigger
            if CommonUtil.isEmpty(strUrlTrigger as AnyObject) == true {
                strURL = (URL(fileURLWithPath: Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "www") ?? "")).absoluteString
            }
            
            // URL 갱신
            self.loadRequest(strURL)
        }
    }
    
    // 진입 URL
    func getEnterUrlPath() -> String? {
        return enter_url_path
    }
    
    // URL 갱신
    func loadRequest(_ strUrl: String?) {
        
        if let strUrl = strUrl {
            // 한글 엔코딩 처리
            let encodedData = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            
            let url = URL(string: encodedData ?? "")
            loadRequest(url)
        }
    }
    
    // URL 갱신
    func loadRequest(_ url: URL?) {
        if CommonUtil.isEmpty(url as AnyObject) {
            return
        }
        
        let request: NSMutableURLRequest? = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: DEF_TIMEOUT_INTERVAL)
        if let request = request {
            old_request = request
            webView?.load(request as URLRequest)
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
    
    // MARK: - Class Method
    static func sharedProcessPool() -> WKProcessPool? {
        var sharedProcessPool: WKProcessPool? = nil
        
        var onceToken: Int = 0
        
        if (onceToken == 0) {
            sharedProcessPool = WKProcessPool()
        }
        onceToken = 1
        
        return sharedProcessPool
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    
    // 요청을 다운로드하기 위해 연결에서 챌린지를 인증해야 할 때 전송됩니다.
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("Allowing all")
        
        if challenge.previousFailureCount == 0 {
            let persistence: URLCredential.Persistence = .forSession
            let credential = URLCredential(user: "username", password: "password", persistence: persistence)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        } else {
            if let error = challenge.error {
                print("\(#function): challenge.error = \(error)")
            }
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
    }
    
    // 웹보기에서 웹 콘텐츠를 받기 시작할 때 호출됩니다.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("1. didCommitNavigation")
    }
    
    // 탐색을 허용할지 또는 취소할지 여부를 결정합니다.
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url: URL = navigationAction.request.url!
        print("host - \(url.host ?? "")")
        print("path - \(url.path)")
        
        print("start absoluteString - \(url.absoluteString)")
        
        // about:blank 무시
        if (url.absoluteString == "about:blank") {
            decisionHandler(WKNavigationActionPolicy.cancel) // cancel the navigation
            return
        }
        
        // allow the navigation
        decisionHandler(WKNavigationActionPolicy.allow)
        
        // cancel the navigation
//        decisionHandler(WKNavigationActionPolicy.cancel)
    }
    
    // 네비게이션이 완료하면 호출됩니다.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("2. didFinishNavigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("3. didFailNavigation")
    }
    
    // 웹보기에서 콘텐츠를로드하는 중에 오류가 발생하면 호출됩니다.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("3. didFailProvisionalNavigation")
        
        // cfurlErrorTimedOut(-1001) : 연결 시간이 초과되었습니다.
        // cfurlErrorCannotFindHost(-1003) : 호스트를 찾을 수 없기 때문에 연결에 실패했습니다.
        // cfurlErrorCannotConnectToHost(-1004) : 호스트에 연결할 수 없어 연결이 실패했습니다.
        // cfurlErrorNetworkConnectionLost(-1005) : 네트워크 연결이 끊어져 연결이 실패했습니다.
        // cfurlErrorNotConnectedToInternet(-1009) : 장치가 인터넷에 연결되어 있지 않기 때문에 연결에 실패했습니다.
        let error: NSError = error as NSError
        if error.code == CFNetworkErrors.cfurlErrorTimedOut.rawValue ||
            error.code == CFNetworkErrors.cfurlErrorCannotFindHost.rawValue ||
            error.code == CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue ||
            error.code == CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue ||
            error.code == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue {
            
        }
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    
    // 웹 페이지에서 스크립트 메시지를 받으면 호출됩니다.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == "loginAction" {
//            print("JavaScript is sending a message \(message.body)")
//        }
    }
}

extension BaseWebViewController: WKUIDelegate {
    
    // 새 웹보기를 만듭니다.
    // this handles target=_blank & window.open links by opening them in a new view
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        return nil
    }
    
    // DOM 윈도우가 성공적으로 닫혔다는 것을 앱에 알립니다.
    // window.close() or self.close() javascript event
    func webViewDidClose(_ webView: WKWebView) {
        print("webViewDidClose")
        
    }
    
    // JavaScript 경고 패널을 표시합니다.
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let popup = AlertMessagePopup.messagePopup(message: message)
        popup.addActionConfirmClick("확인", handler: {
            completionHandler()
        })
    }
    
    // 지정된 메시지가있는 JavaScript 확인 ​​패널을 표시합니다.
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let popup = AlertMessagePopup.messagePopup(message: message)
        popup.addActionConfirmClick("확인", handler: {
            completionHandler(true)
        })
        
        popup.addActionCancelClick("취소", handler: {
            completionHandler(false)
        })
    }
    
    // JavaScript 텍스트 입력 패널을 표시하고 입력 된 텍스트를 리턴합니다.
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
		
		var dicConfig: [String: Any] = [:]
		dicConfig["TITLE"] = prompt
		dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.default
		
		let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick("확인") { (message) in
			if CommonUtil.isEmpty(message as AnyObject) == false {
				debugPrint("\(String(describing: message!))")
				
				completionHandler(message)
			}
			else {
				completionHandler(defaultText)
			}
		}
		
		popup.addActionCancelClick("취소", handler: {
			completionHandler(nil)
		})
    }
}
