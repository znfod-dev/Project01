//
//  CalendarDayCell.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
	
//	@IBOutlet weak var vHolidayCircle: UIView!
	@IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var vToDay: RoundLineView!
    @IBOutlet weak var lbHoliday: UILabel!
    @IBOutlet weak var lbDayLunar: UILabel!

	@IBOutlet var vPageControl: CustomPageControlView!
	@IBOutlet weak var vPageControlWidthConstraint: NSLayoutConstraint!

    func setCellInfo(_ infoData: [String: Any]) {
        
        if CommonUtil.isEmpty(infoData as AnyObject) {
            return
        }
		
        let day: Int = infoData["day"] as! Int
        let cellIndex: Int = infoData["cellIndex"] as! Int
        let monthDirection: Int = infoData["monthDirection"] as! Int
        let isHoliday: Bool = infoData["isHoliday"] as! Bool
		var todoCount: Int = infoData["todoCount"] as! Int
        let holidayName: String = infoData["holidayName"] as! String

        var monthLunar: Int = 0
        var dayLunar: Int = 0
        
        // 음력
        if infoData.index(forKey: "monthLunar") != nil {
            monthLunar = infoData["monthLunar"] as! Int
        }
        
        if infoData.index(forKey: "dayLunar") != nil {
            dayLunar = infoData["dayLunar"] as! Int
        }
		
		lbDay.text = "\(day)"

		var colorDay = 0xBBBBBB

		// 현재달
		if monthDirection == 0 {
			var orgColorDay = 0x1E1E1E
			var colorHolidayCircle = 0xF9553C
			
//			vHolidayCircle.isHidden = true
			lbHoliday.isHidden = true
//			lbDayLunar.isHidden = true
			vPageControl.isHidden = true

			// 공휴일 체크
			if isHoliday == true {
				orgColorDay = 0xF9553C
/*
				// 공휴일 동그라미
				if CommonUtil.isEmpty(holidayName as AnyObject) == false {
					vHolidayCircle.isHidden = false
					vHolidayCircle.backgroundColor = UIColor(hex: orgColorDay)
				}
				else {
					vHolidayCircle.isHidden = true
				}
*/
			}
			
			colorDay = orgColorDay
			
			// 오늘일 경우
			if CalendarManager.getTodayIndex() == cellIndex {
				vToDay.isHidden = false
				
				vToDay.borderWidth = 0.0
				vToDay.backgroundColor = UIColor(hex: 0x8578DF)
				
				colorDay = 0xFFFFFF
				colorHolidayCircle = colorDay
			}
			else {
				vToDay.isHidden = true
			}
			
			// 셀선택
			if CalendarManager.selectedCell == cellIndex {
				vToDay.isHidden = false
				vToDay.borderWidth = 2.0
				vToDay.backgroundColor = UIColor.clear
				
				// 공휴일 일때...
				if isHoliday == true {
					colorHolidayCircle = 0xF9553C
					vToDay.borderColor = UIColor(hex: colorHolidayCircle)
					
					// 공휴일명 세팅
					lbHoliday.isHidden = false
					lbHoliday.text = holidayName
				}
				else {
					vToDay.borderColor = UIColor(hex: 0x8578DF)
				}
				
				colorDay = orgColorDay
			}

//			vHolidayCircle.backgroundColor = UIColor(hex: colorHolidayCircle)
			
			// 음력 표시
			if monthLunar == 0 || dayLunar == 0 {
//				lbDayLunar.isHidden = true
			}
			else {
				// 이전 음력설정과 변경유무 체크
				let isLunarCalendar = !CommonUtil.getUserDefaultsBool(forKey: kBool_isLunarCalendar)
//				lbDayLunar.isHidden = isLunarCalendar
				lbDayLunar.text = String(format: "%02d.%02d", monthLunar, dayLunar)
			}
			
			// Todo List
			if todoCount == 0 {
				vPageControl.isHidden = true
			}
			// 공휴일명 표시하고 있으면...
			else if lbHoliday.isHidden == true {
				// 최대 3개까지 표시해준다.
				if todoCount > 3 {
					todoCount = 3
				}
				
				let gapWidth: CGFloat = 5.0
				// 페이지 컨트롤
				vPageControl.gapWidth = gapWidth
				vPageControl.normalItem = UIColor(hex: 0x8578DF)
				vPageControl.selectedItem = UIColor(hex: 0x8578DF)
				vPageControl.setTotalPage(todoCount)
				// 10px : 이미지 크기 8px 이미지 간격
				vPageControlWidthConstraint.constant = (vPageControl.frame.size.height * CGFloat(todoCount) + gapWidth * CGFloat(todoCount-1))
				
				vPageControl.isHidden = false
			}
		}
		// -1 or 1 이면 이전달, 다음달
		else {
//			vHolidayCircle.isHidden = true
			vToDay.isHidden = true
			lbHoliday.isHidden = true
//			lbDayLunar.isHidden = true
			vPageControl.isHidden = true
		}
		
		lbDay.textColor = UIColor(hex: colorDay)
    }
}
