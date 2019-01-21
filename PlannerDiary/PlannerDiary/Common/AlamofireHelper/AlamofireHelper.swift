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
	static func requestGET(_ url: URLConvertible, parameters: Parameters? = nil, completionHandler: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
		
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
					completionHandler(value as Any, nil)
				case .failure(let error):
					completionHandler(nil, error as NSError)
				}
/*
				switch response.result {
				case .failure(let error):
					// Do whatever here
					completionBlock(error as? [String : AnyObject], nil)
					return
					
				case .success(let response):
					// First make sure you got back a dictionary if that's what you expect
					guard let json = response as? [String : AnyObject] else {
						return
					}
					
					print(json["response"]!)
					
					// Then make sure you get the actual key/value types you expect
//					guard var points = json["points"] as? Double,
//						let additions = json["additions"] as? [[String : AnyObject]],
//						let used = json["used"] as? [[String : AnyObject]] else {
//							NSAlert.okWithMessage("Failed to get data from webserver")
//							return
//					}
//				if let JSON = response.result.value {
//					print(JSON["response"])
//				}
				}
*/
		}
	}
	
	// POST
	static func requestPOST(_ url: URLConvertible, parameters: Parameters? = nil) {
		
		Alamofire.request(
			url,
			method: .post,
			parameters: [:],
			encoding: URLEncoding.default,
			headers: ["Content-Type":"application/json", "Accept":"application/json"]
			)
			.validate(statusCode: 200..<300)
			.responseJSON {
				response in
				if let JSON = response.result.value {
					print(JSON)
				}
		}
	}
}
