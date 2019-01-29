//
//  Define.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 15..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Device Define
// 스크린 크기
let DEF_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
let DEF_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

// 스케일 기준 사이즈
let DEF_SCREEN_375_WIDTH: CGFloat = 375.0
let DEF_SCREEN_375_HEIGHT: CGFloat = 667.0

// 375화면 기준 스케일값
let DEF_WIDTH_375_SCALE: CGFloat = (DEF_SCREEN_WIDTH < DEF_SCREEN_HEIGHT) ? (DEF_SCREEN_WIDTH / DEF_SCREEN_375_WIDTH) : (DEF_SCREEN_HEIGHT / DEF_SCREEN_375_WIDTH)


// MARK: - NSUserDefaults Key Define
// 앱 최초 실행했는지
let kBool_isFirstAppRun = "isFirstAppRunKey"
