//
//  DiaryTableCell.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryTableCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var todoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var diaryTextView: UITextView!
    
    var todoList = Array<ModelTodo>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DiaryTableCell numberOfRowsInSection : \(self.todoList.count)")
        return self.todoList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("DiaryTableCell cellForRowAt")
        let cell:DiaryTotoTableCell = tableView.dequeueReusableCell(withIdentifier: "DiaryTodo") as! DiaryTotoTableCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("DiaryTableCell heightForRowAt")
        return 40
        
    }
}
