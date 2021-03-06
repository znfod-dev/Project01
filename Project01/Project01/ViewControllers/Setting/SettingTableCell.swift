//
//  SettingTableCell.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var lastDateLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    @IBOutlet weak var lunarSwitch: UISwitch!
    @IBOutlet weak var iCloudSwitch: UISwitch!
    @IBOutlet weak var pagingBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
