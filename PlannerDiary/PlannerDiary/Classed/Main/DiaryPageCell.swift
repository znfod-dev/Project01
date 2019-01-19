//
//  DiaryPageCell.swift
//  PlannerDiary
//
//  Created by 김삼현 on 06/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class DiaryPageCell: UITableViewCell {

	@IBOutlet weak var lbHour: UILabel!
	@IBOutlet weak var lbContents: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
