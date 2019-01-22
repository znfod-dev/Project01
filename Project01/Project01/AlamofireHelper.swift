//
//  AlamofireHelper.swift
//  PlannerDiary
//
//  Created by 김삼현 on 21/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireHelper: NSObject {

	// 공통 파라메터 세팅
	static func requestParameters() -> [String: String] {
		var param: [String: String] = [:]
		
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			param["VERSION"] = version
		}
		
		return param
	}
	
	// GET
    static func requestGET(_ url: URLConvertible, parameters: Parameters? = nil, success: @escaping (_ response: [String : Any]?) -> (), failure: @escaping (_ error: Error?) -> ()) {
		
        Alamofire.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                
                switch response.result {
                case .success(let value):
                    success(value as? [String : Any])
                case .failure(let error):
                    failure(error)
                }
        }
	}
	
	// POST
	static func requestPOST(_ url: URLConvertible, parameters: Parameters? = nil, success: @escaping (_ response: [String : Any]?) -> (), failure: @escaping (_ error: Error?) -> ()) {
		
        Alamofire.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                
                switch response.result {
                case .success(let value):
                    success(value as? [String : Any])
                case .failure(let error):
                    failure(error)
                }
        }
	}
}
