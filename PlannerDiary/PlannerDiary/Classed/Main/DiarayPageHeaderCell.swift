//
//  DiarayPageHeaderCell.swift
//  PlannerDiary
//
//  Created by 김삼현 on 06/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class DiarayPageHeaderCell: UITableViewCell {

	@IBOutlet weak var lbMonth: UILabel!
	@IBOutlet weak var lbWeek: UILabel!
	@IBOutlet weak var lbDay: UILabel!
	@IBOutlet weak var ivBackground: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
