//
//  AlamofireHelper.swift
//  PlannerDiary
//
//  Created by 김삼현 on 21/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import Alamofire

// 네트워크 타임아웃 인터벌
let DEF_TIMEOUT_INTERVAL: TimeInterval = 10.0


class AlamofireHelper: NSObject {
    
    static var alamoFireManager: SessionManager? // this line

	// 공통 파라메터 세팅
	static func requestParameters() -> [String: Any] {
		var param: [String: Any] = [:]
		
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			param["VERSION"] = version
		}
		
		return param
	}
	
	// GET
    static func requestGET(_ url: URLConvertible, parameters: Parameters? = nil, success: @escaping (_ response: [String : Any]?) -> (), failure: @escaping (_ error: Error?) -> ()) {
		
        let isNotShowLoader: Bool = (parameters!["isNotShowLoader"] != nil)
        
        // 로딩 스피너 활성화 여부
        if isNotShowLoader == false {
            // 로딩 스피너 활성화
            CommonUtil.showLoaderCount()
        }
        
        // alamoFireManager 초기화
        if AlamofireHelper.alamoFireManager == nil {
            // 타임 인터벌
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = DEF_TIMEOUT_INTERVAL
            configuration.timeoutIntervalForResource = DEF_TIMEOUT_INTERVAL
            AlamofireHelper.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        }
        
        guard let alamoFireManager = AlamofireHelper.alamoFireManager else {
            // 로딩 스피너 활성화 여부
            if isNotShowLoader == false {
                // 로딩 스피너 비활성화
                CommonUtil.hideLoaderCount()
            }

            return
        }

        alamoFireManager.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                // 로딩 스피너 활성화 여부
                if isNotShowLoader == false {
                    // 로딩 스피너 비활성화
                    CommonUtil.hideLoaderCount()
                }
                
                switch response.result {
                case .success(let value):
                    success(value as? [String : Any])
                case .failure(let error):
                    failure(error)
                    
                    // 공통 네트워크 에러코드 처리
                    AlamofireHelper.responseErrorCode(error: error as NSError)
                }
        }
	}
	
	// POST
	static func requestPOST(_ url: URLConvertible, parameters: Parameters? = nil, success: @escaping (_ response: [String : Any]?) -> (), failure: @escaping (_ error: Error?) -> ()) {
		
        let isNotShowLoader: Bool = (parameters!["isNotShowLoader"] != nil)
        // 로딩 스피너 활성화 여부
        if isNotShowLoader == false {
            // 로딩 스피너 활성화
            CommonUtil.showLoaderCount()
        }
        
        // alamoFireManager 초기화
        if AlamofireHelper.alamoFireManager == nil {
            // 타임 인터벌
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = DEF_TIMEOUT_INTERVAL
            configuration.timeoutIntervalForResource = DEF_TIMEOUT_INTERVAL
            AlamofireHelper.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        }
        
        guard let alamoFireManager = AlamofireHelper.alamoFireManager else {
            // 로딩 스피너 활성화 여부
            if isNotShowLoader == false {
                // 로딩 스피너 비활성화
                CommonUtil.hideLoaderCount()
            }
            
            return
        }
        
        alamoFireManager.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                // 로딩 스피너 활성화 여부
                if isNotShowLoader == false {
                    // 로딩 스피너 비활성화
                    CommonUtil.hideLoaderCount()
                }

                switch response.result {
                case .success(let value):
                    success(value as? [String : Any])
                case .failure(let error):
                    failure(error)
                    
                    // 공통 네트워크 에러코드 처리
                    AlamofireHelper.responseErrorCode(error: error as NSError)
                }
        }
	}
    
    // 공통 네트워크 에러코드 처리
    static func responseErrorCode(error: NSError?) {
        
        if let error = error as NSError? {
            if (error.code == CFNetworkErrors.cfurlErrorTimedOut.rawValue ||
                error.code == CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue ||
                error.code == CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue ||
                error.code == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue) {
                
                let popup = AlertMessagePopup.messagePopup(message: "데이터를 정상적으로 불러오지 못했습니다.\n네트워크 상태 확인 후 다시 시도해주세요.")
                popup.addActionConfirmClick("확인", handler: {
                    
                })
            }
        }
    }
}
