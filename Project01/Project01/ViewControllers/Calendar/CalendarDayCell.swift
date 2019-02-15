//
//  CalendarDayCell.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
	
	@IBOutlet weak var vHolidayCircle: UIView!
	@IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var vToDay: UIView!
	@IBOutlet weak var vSelectedCell: UIView!
    @IBOutlet weak var vHoliday: UIView!
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
        
        if monthLunar == 0 || dayLunar == 0 {
            lbDayLunar.isHidden = true
        }
        else {
			// 이전 음력설정과 변경유무 체크
			let isLunarCalendar = !CommonUtil.getUserDefaultsBool(forKey: kBool_isLunarCalendar)
            lbDayLunar.isHidden = isLunarCalendar
            lbDayLunar.text = String(format: "%02d.%02d", monthLunar, dayLunar)
        }
        
        lbDay.text = "\(day)"
        
        // 현재달
        if monthDirection == 0 {
            // 오늘일 경우
            if CalendarManager.getTodayIndex() == cellIndex {
                lbDay.textColor = UIColor.white
                vToDay.isHidden = false
            }
            else {
                lbDay.textColor = UIColor(hex: 0x2E2E39)
                vToDay.isHidden = true
            }
        }
        // -1 or 1 이면 이전달, 다음달
        else {
            lbDay.textColor = UIColor(hex: 0xBBBBBB)
            vToDay.isHidden = true
        }
		
        // 공휴일 체크
        if isHoliday == true {
			// 공휴일 동그라미
//			if CommonUtil.isEmpty(holidayName as AnyObject) == false {
//				vHolidayCircle.isHidden = false
//			}
//			else {
//				vHolidayCircle.isHidden = true
//			}
			
			// 현재달
			if monthDirection == 0 {
				// 오늘일 경우
				if CalendarManager.getTodayIndex() == cellIndex {
//					vHolidayCircle.backgroundColor = UIColor(hex: 0xffffff)
					lbDay.textColor = UIColor(hex: 0xffffff)
					vToDay.backgroundColor = UIColor(hex: 0x8578DF)
					vToDay.isHidden = false
				}
				else {
//					vHolidayCircle.backgroundColor = UIColor(hex: 0xF9553C)
					lbDay.textColor = UIColor(hex: 0xF9553C)
					vToDay.isHidden = true
				}
			}
			// -1 or 1 이면 이전달, 다음달
			else {
				// 오늘일 경우
				if CalendarManager.getTodayIndex() == cellIndex {
//					vHolidayCircle.backgroundColor = UIColor(hex: 0xffffff)
					lbDay.textColor = UIColor(hex: 0xffffff)
					vToDay.backgroundColor = UIColor(hex: 0x8578DF)
					vToDay.isHidden = false
				}
				else {
//					vHolidayCircle.backgroundColor = UIColor(hex: 0xF9553C)
					lbDay.textColor = UIColor(hex: 0xBBBBBB)
					vToDay.isHidden = true
				}
			}
        }
        else {
			// 공휴일 동그라미
//			vHolidayCircle.isHidden = true
			
			// 현재달
			if monthDirection == 0 {
				// 오늘일 경우
				if CalendarManager.getTodayIndex() == cellIndex {
					lbDay.textColor = UIColor.white
					vToDay.backgroundColor = UIColor(hex: 0x8578DF)
					vToDay.isHidden = false
				}
				else {
					lbDay.textColor = UIColor(hex: 0x2E2E39)
					vToDay.isHidden = true
				}
			}
			// -1 or 1 이면 이전달, 다음달
			else {
				// 오늘일 경우
				if CalendarManager.getTodayIndex() == cellIndex {
					lbDay.textColor = UIColor.white
					vToDay.backgroundColor = UIColor(hex: 0x8578DF)
					vToDay.isHidden = false
				}
				else {
					lbDay.textColor = UIColor(hex: 0xBBBBBB)
					vToDay.isHidden = true
				}
			}
        }
		
		// 셀선택
		if CalendarManager.selectedCell == cellIndex {
//			vSelectedCell.isHidden = false
			
			// 선택했을때 공휴일 표시
			if CommonUtil.isEmpty(holidayName as AnyObject) == false {
				vHoliday.isHidden = false
				lbHoliday.text = holidayName
			}
			else {
				vHoliday.isHidden = true
			}
		}
		else {
//			vSelectedCell.isHidden = true
			vHoliday.isHidden = true
		}
		
		// Todo List
		if todoCount == 0 {
			vPageControl.isHidden = true
		}
		else {
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
}
