//
//  CalendarDayCell.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
    
	@IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var vToDay: UIView!
	@IBOutlet weak var vSelectedCell: UIView!
    @IBOutlet weak var vHoliday: UIView!
    @IBOutlet weak var lbHoliday: UILabel!

    func setCellInfo(_ infoData: [String: Any]) {
        
        if CommonUtil.isEmpty(infoData as AnyObject) {
            return
        }
        
        let day: Int = infoData["day"] as! Int
        let cellIndex: Int = infoData["cellIndex"] as! Int
        let isCurentMonth: Bool = infoData["isCurentMonth"] as! Bool
        let isHoliday: Bool = infoData["isHoliday"] as! Bool
        let holidayName: String = infoData["holidayName"] as! String

        lbDay.text = "\(day)"
        if isCurentMonth == true {
            // 오늘일 경우
            if CalendarManager.getTodayIndex() == cellIndex {
                lbDay.textColor = UIColor.white
                vToDay.isHidden = false
            }
            else {
                lbDay.textColor = UIColor.black
                vToDay.isHidden = true
            }
        }
        else {
            lbDay.textColor = UIColor.lightGray
            vToDay.isHidden = true
        }
		
		// 셀선택
		if CalendarManager.selectedCell == cellIndex {
			vSelectedCell.isHidden = false
		}
		else {
			vSelectedCell.isHidden = true
		}
        
        // 공휴일 체크
        if isHoliday == true {
            vHoliday.isHidden = false
            lbHoliday.text = holidayName
        }
        else {
            vHoliday.isHidden = true
        }
    }
}
