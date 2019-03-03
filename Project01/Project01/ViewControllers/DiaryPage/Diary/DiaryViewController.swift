//
//  DiaryViewController.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCancelBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // 모달인가?
    var isModal: Bool = false
    
    var selectedMonth = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 데이터 받아 오기
        self.searchView.isHidden = true
        self.tableView.reloadData()
    }
    
    // MARK:- @IBAction
    @IBAction func menuBtnClicked(_ sender: Any) {
        print("onMenuClick")
        sideMenuController?.revealMenu()
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
        self.searchView.isHidden = false
        
    }
    @IBAction func searchCancelBtnClicked(_ sender: Any) {
        self.searchView.isHidden = true
    }
    @IBAction func writeBtnClicked(_ sender: Any) {
    
    }
    @IBAction func planBtnClicked(_ sender: Any) {
    
    }
    
    
}
