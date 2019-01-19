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
	
    func setCellInfo(_ infoData: (year:Int, month:Int, day:Int, cellIndex:Int, isCurentMonth:Bool)) {
        if CommonUtil.isEmpty(infoData as AnyObject) {
            return
        }
        
        lbDay.text = "\(infoData.day)"
        if infoData.isCurentMonth == true {
            // 오늘일 경우
            if CalendarManager.getTodayIndex() == infoData.cellIndex {
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
		if CalendarManager.selectedCell == infoData.cellIndex {
			vSelectedCell.isHidden = false
		}
		else {
			vSelectedCell.isHidden = true
		}
    }
}
