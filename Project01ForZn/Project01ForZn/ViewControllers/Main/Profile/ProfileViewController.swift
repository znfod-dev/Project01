//
//  ProfileViewController.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var textViewText = String()
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        print("Profile viewdidload")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { any in
            
        }
        self.setTableSetting()
        
        let maxDate = DBManager.shared.loadMaximumDateFromUD()
        print("maxDate : \(maxDate)")
        let minDate = DBManager.shared.loadMinimumDateFromUD()
        print("minDate : \(minDate)")
        let font = DBManager.shared.loadFontFromUD()
        print("font : \(font)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func settingBarBtnClicked(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let viewController:SettingViewController = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setTableSetting() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        textView.sizeToFit()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
}
