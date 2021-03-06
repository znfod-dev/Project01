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
    
    // calendar에서 왔는가
    var isFromCalendar = false
    
    // search Mode
    var isSearchMode = false
    
    var selectedYear = 0
    var selectedMonth = 0
    
    // 년도 list
    var yearList = Array<Int>()
    // 월 list
    var monthList = Array<Int>()
    // 월간 일자
    var dayOfMonthList = Array<Int>()
    
    var diaryList = Array<ModelDiary>()
    var diaryEditList = Array<Bool>()
    
    // 검색모드에서 검색된 DiaryList
    var searchedDiaryList = Array<ModelDiary>()
    var searchedDiaryEditList = Array<Bool>()
    
    var yearPickerHideY:CGFloat = 0
    var yearPickerShowY:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // 데이터 받아 오기
        self.searchView.isHidden = true
        self.firstInit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        
        self.setDateData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.yearPickerHideY = self.yearPickerView.frame.origin.y
        self.yearPickerShowY = self.yearPickerView.frame.origin.y - self.yearPickerView.frame.height
    }
    
    
    // MARK:- 첫 시작 setDatabase
    
    func firstInit() {
        print("firstInit")
        
        self.yearPickerView = PickerView.initWithNib(frame: self.view.frame)
        self.yearPickerView.pickerView.delegate = self
        self.yearPickerView.pickerView.dataSource = self
        
        
        let yearSubmit = UITapGestureRecognizer(target: self, action: #selector(handleYearSubmit))
        self.yearPickerView.submitBtn.addGestureRecognizer(yearSubmit)
        
        self.view.addSubview(self.yearPickerView)
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: Date())
        
        self.selectedYear = components.year!
        self.selectedMonth = components.month!
        print("self.selectedYear : \(self.selectedYear)")
        self.setDateData()
        DispatchQueue.main.async {
            self.yearLabel.text = String("\(self.selectedYear) 년")
        }
        
        self.loadDiary()
    }
    // load diary
    func loadDiary() {
        print("loadDiary")
        self.diaryList.removeAll()
        self.diaryEditList.removeAll()
        let date = Date.Get(year: self.selectedYear, month: self.selectedMonth, day: 1)
        self.diaryList = DBManager.shared.selectDiaryList(date: date)
        
        for _ in self.diaryList {
            self.diaryEditList.append(false)
        }
        self.tableView.reloadData()
    }
    
    
    // 최대 최소 년도 설정
    func setDateData() {
        print("setDateData")
        
        // 최소 일
        let minDate = DBManager.shared.loadMinimumDateFromUD()
        // 최대 일
        let maxDate = DBManager.shared.loadMaximumDateFromUD()
        // 최소 년도
        let minYear = minDate.getYear()
        // 최대 년도
        let maxYear = maxDate.getYear()
        if yearList.count > 0 {
            
            let yearListMin = yearList[0]
            let yearListMax = yearList.last
            if (yearListMax != maxYear) || (minYear != yearListMin) {
                yearList.removeAll()
                // 년도 리스트
                for year in minYear ..< maxYear+1 {
                    yearList.append(year)
                }
            }
        }else {
            // 년도 리스트
            for year in minYear ..< maxYear+1 {
                yearList.append(year)
            }
        }
        if self.selectedYear > maxYear || self.selectedYear < minYear {
            self.selectedYear = minYear
            DispatchQueue.main.async {
                self.yearLabel.text = String("\(self.selectedYear) 년")
            }
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
        self.view.endEditing(true)
        self.isSearchMode = false
        self.searchedDiaryList.removeAll()
        self.searchedDiaryEditList.removeAll()
        self.tableView.reloadData()
        self.searchView.isHidden = true
    }
    @IBAction func editBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        print("editBtnClicked : \(tag)")
        let edited = self.diaryEditList[tag]
        if edited == true {
            self.diaryEditList[tag] = false
            let cell:DiaryTableCell = tableView.cellForRow(at: IndexPath(row: 0, section: tag)) as! DiaryTableCell
            let diary = diaryList[tag]
            diary.diary = cell.diaryTextView.text
            DBManager.shared.updateDiary(diary: diary)
            
        }else {
            self.diaryEditList[tag] = true
        }
        let indexPath = IndexPath.init(row: 0, section: tag)
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
    @IBAction func todoBtnClicked(_ sender: Any) {
        
    }
    
    @objc func handleYearSubmit() {
        print("handleYearSubmit")
        let row = self.yearPickerView.pickerView.selectedRow(inComponent: 0)
        self.selectedYear = yearList[row]
        self.loadDiary()
        self.yearPickerView.dismissPickerView()
    }
    
    // MARK:- Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        print("keyboardWillShow")
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: kbSize.height, right: 0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("keyboardWillHide")
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
}
