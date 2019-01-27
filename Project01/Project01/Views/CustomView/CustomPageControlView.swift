//
//  CustomPageControlView.swift
//  PlannerDiary
//
//  Created by 김삼현 on 27/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class CustomPageControlView: UIView {

	// 총 페이지 수
	var totalPageCount: Int = 0
	// 선택한 페이지 인덱스
	var currentPage: Int = -1
	// 간격
	var gapWidth: CGFloat = 10.0
	// 색상
	var normalItem: UIColor = UIColor.white
	// 선택 색상
	var selectedItem: UIColor = UIColor.red

	// 페이지 뷰 배열
	var arrPage = [UIView]()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadLayout()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadLayout()
	}
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	func loadLayout() {
		backgroundColor = UIColor.clear
	}
	
	func initGUI() {
		
		arrPage.removeAll()
		
		// 모두 지워준다
		for view: UIView in subviews {
			view.removeFromSuperview()
		}
		
		currentPage = -1
		
		var frame: CGRect = bounds
		var posX: CGFloat = 0
		let height: CGFloat = frame.size.height
		frame.size.width = height
		
		for _ in 0..<totalPageCount {
			let vIndicator = UIView(frame: CGRect(x: posX, y: 0, width: height, height: height))
			vIndicator.layer.cornerRadius = height / 2
			
			arrPage.append(vIndicator)
			addSubview(vIndicator)
			
			posX += height + gapWidth
		}
		
		setSelectPage(0)
	}
	
	func setTotalPage(_ totalPage: Int) {
		totalPageCount = totalPage
		
		initGUI()
	}
	
	func getSelectPage() -> Int {
		return currentPage
	}
	
	func setSelectPage(_ page: Int) {
		currentPage = page
		
		for i in 0..<arrPage.count {
			let vIndicator: UIView? = arrPage[i]
			if let vIndicator = vIndicator {
				if i == currentPage {
					vIndicator.backgroundColor = selectedItem
					vIndicator.layer.borderWidth = 0
				} else {
					vIndicator.backgroundColor = normalItem
					vIndicator.layer.borderWidth = 2.0
					vIndicator.layer.borderColor = normalItem.cgColor
				}
			}
		}
	}
}
