//
//  SiceMenuCell.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 18..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class SiceMenuCell: UITableViewCell {

	@IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellInfo(_ dicInfoData: [String:String]?) {

        guard let title = dicInfoData!["TITLE"] else {
            return
        }
		
		guard let iconName = dicInfoData!["IMAGE"] else {
			return
		}
		
		ivIcon.image = UIImage(named: iconName)
		
        lbTitle.text = title
    }
}
