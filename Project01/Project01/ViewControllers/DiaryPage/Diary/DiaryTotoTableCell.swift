//
//  DiaryTotoTableCell.swift
//  Project01
//
//  Created by 박종현 on 11/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryTotoTableCell: UITableViewCell {

    @IBOutlet weak var todoBtn: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
