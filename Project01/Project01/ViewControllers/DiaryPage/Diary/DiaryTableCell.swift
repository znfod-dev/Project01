//
//  DiaryTableCell.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryTableCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var planContentLabel: UILabel!
    
    @IBOutlet weak var createBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
