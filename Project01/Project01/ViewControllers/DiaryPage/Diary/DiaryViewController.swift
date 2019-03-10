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
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCancelBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addDateBtn: UIButton!
    
    var yearPickerView:PickerView!
    
    // 모달인가?
    var isModal: Bool = false
    
    var selectedYear = 0
    var selectedMonth = 0
    
    // 년도 list
    var yearList = Array<Int>()
    // 월간 일자
    var dayOfMonthList = Array<Int>()
    
    var diaryList = Array<ModelDiary>()
    var diaryEditList = Array<Bool>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 데이터 받아 오기
        self.searchView.isHidden = true
        
        self.firstInit()
    }
    
    // MARK:- 첫 시작 setDatabase
    
    func firstInit() {
        
        // 이번달 기록해놓기
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: Date())
        
        self.selectedYear = components.year!
        self.selectedMonth = components.month!
        
        self.yearPickerView = PickerView.initWithNib(frame: self.view.frame)
        self.yearPickerView.pickerView.delegate = self
        self.yearPickerView.pickerView.dataSource = self
        
        let yearSubmit = UITapGestureRecognizer(target: self, action: #selector(handleYearSubmit))
        self.yearPickerView.submitBtn.addGestureRecognizer(yearSubmit)
        
        self.view.addSubview(self.yearPickerView)
        
        self.setMinMaxYear()
        self.loadDiary()
    }
    // load diary
    func loadDiary() {
        let date = Date.Get(year: self.selectedYear, month: self.selectedMonth, day: 1)
        self.diaryList = DBManager.shared.selectDiaryList(date: date)
        self.diaryEditList.removeAll()
        for diary in self.diaryList {
            print("\(diary.id)")
            self.diaryEditList.append(false)
        }
        self.tableView.reloadData()
        
    }
    // 최대 최소 년도 설정
    func setMinMaxYear() {
        // 최소 년도
        let minYear = DBManager.shared.loadMinimumDateFromUD().getYear()
        // 최대 년도
        let maxYear = DBManager.shared.loadMaximumDateFromUD().getYear()
        // 년도 리스트
        for year in minYear ..< maxYear+1 {
            yearList.append(year)
        }
        self.yearPickerView.pickerView.reloadAllComponents()
    }
    
    
    // MARK:- @IBAction
    @IBAction func menuBtnClicked(_ sender: Any) {
        print("onMenuClick")
        sideMenuController?.revealMenu()
    }
    @IBAction func yearBtnClicked(_ sender: Any) {
        
        self.yearPickerView.showPickerView()
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
        self.searchView.isHidden = false
        
    }
    @IBAction func searchCancelBtnClicked(_ sender: Any) {
        self.searchView.isHidden = true
    }
    @IBAction func editBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath.init(row: tag, section: 0)
        self.diaryEditList[tag] = true
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @IBAction func addDateBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "DiaryPage", bundle: nil)
        let alert:DiaryAddViewController = storyboard.instantiateViewController(withIdentifier: "DiaryAdd") as! DiaryAddViewController
        alert.submitClick = {
            self.loadDiary()
        }
        alert.modalPresentationStyle = .overCurrentContext
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    @objc func handleYearSubmit() {
        print("handleYearSubmit")
        let row = self.yearPickerView.pickerView.selectedRow(inComponent: 0)
        self.selectedYear = yearList[row]
        self.loadDiary()
        self.yearPickerView.dismissPickerView()
    }
}
