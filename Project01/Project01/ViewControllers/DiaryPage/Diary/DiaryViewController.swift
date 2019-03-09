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
    
    @IBOutlet weak var addDateLabel: UILabel!
    
    // 모달인가?
    var isModal: Bool = false
    // 오늘
    let today = Date()
    // 이번달 year
    var thisYear:Int = 0
    // 이번달 month
    var thisMonth:Int = 0 // Date + Addon에 못만드나? 만들어보셈
    // 이번달 day
    var thisDay:Int = 0
    
    var selectedYear = 0
    var selectedMonth = 0
    
    
    // 년도 list
    var yearList = Array<String>()
    // 월별 시작 일자 일반적으론 1일이 시작이나 현재 날짜는 현재 일을 시작 만들어준다.
    var startDayList = Array<String>()
    // 월간 일자
    var dayOfMonthList = Array<Int>()
    
    
    var editedArray = Array<Bool>()
    var diaryArray = Array<ModelDiary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 데이터 받아 오기
        self.searchView.isHidden = true
        // 이번달 기록해놓기
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: Date())
        self.thisYear = components.year!
        self.thisMonth = components.month!
        self.thisDay = components.day!
        
        self.selectedYear = components.year!
         self.selectedMonth = components.month!
        
        // 년도 리스트
        for year in 2010..<2030 {
            yearList.append("\(year)")
        }
        
        self.setYear(year: self.thisYear)
        self.setData(date: today)
        
        
    }
    
    // MARK:- 년도 선택 function
    func setYear(year:Int) {
        self.startDayList.removeAll()
        for month in 0..<12 {
            let dateInteger = (year * 10000) + (month * 100) + 1
            self.startDayList.append("\(dateInteger)")
            // let date = Date.Get(year: year, month: month, day: 1)
            
        }
        self.dayOfMonthList = Date.dayOfMonths(year: year)
    }
    
    func setData(date:Date) {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: date)
        let month = components.month
        
        self.diaryArray = DBManager.shared.selectDiary(selectedDate: date)
        self.editedArray.removeAll()
        for _ in 0..<self.dayOfMonthList[month!] {
            self.editedArray.append(false)
        }
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
    @IBAction func editBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        self.editedArray[tag] = true
        let indexPath = IndexPath.init(row: tag, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @IBAction func createDiaryBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let id = Date.GetId(year: selectedYear, month: selectedMonth, day: tag+1)
        let diary = ModelDiary.init()
        diary.id = id
        DBManager.shared.insertDiary(diary: diary)
        let date = Date.Get(year: selectedYear, month: selectedMonth, day: tag+1)
        self.setData(date: date)
    }
}
