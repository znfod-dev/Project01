//
//  MonthlyPlanViewController.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.


import UIKit
import SideMenuSwift
import RealmSwift
import BEMCheckBox


class MonthlyPlanViewController: UIViewController {
    
    @IBOutlet weak var vNavigationBar: UIView!
    @IBOutlet weak var vWeekString: UIView!
    @IBOutlet weak var btnCalendarTitle: UIButton!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var scrollView: InfiniteScrollView!
	@IBOutlet weak var vShadow: UIView!
    @IBOutlet weak var vHLine: UIView!
    @IBOutlet weak var todoListHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var todoListHeaderHeightConstraint: NSLayoutConstraint!
//    @IBOutlet var fixedTodoListInfoView: UIView! // 날짜와 스위치가 포함된 뷰
    @IBOutlet weak var hideSwitch: UISwitch! // hide 스위치
    @IBOutlet weak var todoTableView: UITableView! // tableView
	@IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var todoListDateLabel: UILabel! // todoList에서 날짜 라벨
    @IBOutlet weak var emptyTodoListView: UIView! // TodoList가 없을 때 나타나는 뷰
	@IBOutlet weak var vEmptyMessage: UIView! // TodoList가 없을 때 나타나는 뷰
	@IBOutlet weak var vHiddenMessage: UIView! // TodoList가 없을 때 나타나는 뷰
	
    // 월별뷰컨트롤러 배열
    var arrOriginController = [CalendarMonthViewController]()
    var arrChildController = [CalendarMonthViewController]()
    
    // sama73: 시작일/종료일 샘플
    var startYYYYMMDD = 20181101
    var endYYYYMMDD = 20190301
    
    // 음력 키값
    var isLunarCalendar = false
    
    // 스크롤 Direction(-1: 좌측, 0: 정지, 1: 우측
    var scrollDirection: Int = 0
    
    // 이전 보여주는 페이지
    var focusIndex: Int = -1
    // 선택한 년/월
    var curentDate: (year:Int, month:Int) = (2019, 1)
    
    // 첫번째 이번달호출을 화면완료된후에 실행해줄려고
    var isFirstLoad: Bool = true
    
    // 테이블 뷰
    var todoArray = Array<ModelTodo>() // 전체 TodoList
    var selectedDayTodo = Array<ModelTodo>() // 특정 날짜의 TodoList
    
    var selectedDate:String? = Date().cmpString() // 선택한 날짜
    
    // 완료된 todo 숨기기
    // true : 체크 todo 숨기기
    // false : 모든 todo 보여주기
    var isHide: Bool = UserDefaults.standard.bool(forKey: "isHide")
    
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        // 그림자 처리
        vNavigationBar.layer.shadowColor = UIColor(hex: 0xAAAAAA).cgColor
        vNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 7)
        vNavigationBar.layer.shadowOpacity = 0.16

		vShadow.layer.shadowColor = UIColor.black.cgColor
		vShadow.layer.shadowOffset = CGSize(width: 0, height: 3)
		vShadow.layer.shadowOpacity = 0.1
		
		btnAdd.layer.shadowColor = UIColor(hex: 0x8578DF).cgColor
		btnAdd.layer.shadowOffset = CGSize(width: 0, height: 8)
		btnAdd.layer.shadowOpacity = 0.2
        
        // 테이블 뷰 구분선 삭제
        self.todoTableView.separatorStyle = .none
        
        // 오늘 년/월 구하기
        self.curentDate = CalendarManager.getYearMonth(amount: 0)
        
        // 매월 셀 세팅해서 추가해주기
        if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
            for _ in 0..<3 {
                if let monthVC: CalendarMonthViewController = (storyboard.instantiateViewController(withIdentifier: "CalendarMonthViewController") as? CalendarMonthViewController) {
                    monthVC.parentVC = self
                    monthVC.view.frame = scrollView.bounds
                    self.addChild(monthVC)
                    // 월별뷰컨트롤러 배열
                    self.arrOriginController.append(monthVC)
                }
            }
            
            if self.isHide { // Hide 상태라면 hide버튼을 show로 변경
                self.hideSwitch.setOn(false, animated: true)
            }
            
            // 오늘 날짜로 선택날짜 TodoList에 넣기
            self.selectedDayTodoList()
            
            print("HD = \(NSHomeDirectory())")
        }
        
        // 스위치 크기 줄이기
        self.hideSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var isRefresh = false
        
        // 이전 음력설정과 변경유무 체크
        let isLunarCalendar = CommonUtil.getUserDefaultsBool(forKey: kBool_isLunarCalendar)
        if self.isLunarCalendar != isLunarCalendar {
            self.isLunarCalendar = isLunarCalendar
            isRefresh = true
        }
        
        // 시작 날짜, 마지막 날짜 변경 사항이 있으면 갱신해준다.
        let startDate = DBManager.shared.loadMinimumDateFromUD()
        let endDate = DBManager.shared.loadMaximumDateFromUD()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyyMMdd"
        let startDate2 = formatter.string(from: startDate)
        let endDate2 = formatter.string(from: endDate)
        
        let start: Int = Int(startDate2)!
        let end: Int = Int(endDate2)!
        
        // 시작일, 종료일이 변경되었으면 달력데이터 정보 갱신
        if startYYYYMMDD != start || endYYYYMMDD != end {
            startYYYYMMDD = start
            endYYYYMMDD = end
            
            print("startDate=\(startYYYYMMDD)")
            print("endDate=\(endYYYYMMDD)")
            
            // 첫번째 이번달 호출시 화면 완료된 이후에 호출해준다.
            if isFirstLoad == false {
                goThisMonth()
            }
        }
            // 음력설정이 변경된 경우...
        else if isRefresh == true {
            // 콜렉션뷰 전체 리로드
            collectionReloadDataAll()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 첫번째 이번달 호출시 화면 완료된 이후에 호출해준다.
        if isFirstLoad == true {
            isFirstLoad = false
            goThisMonth()
        }
    }
    
    // 설정할 년/월 재갱신
    func setDBReloadData() {
        for monthVC in self.arrChildController {
            monthVC.setDBReloadData()
        }
    }
    
    // 콜렉션뷰 전체 리로드
    func collectionReloadDataAll() {
        for monthVC in self.arrChildController {
            monthVC.collectionView.reloadData()
        }
    }
    
    // 기본 선택 날짜
    func defaultSelectDate(year:Int, month:Int) {
		
		// 콜렉션뷰 전체 리로드
		collectionReloadDataAll()

        // 선택한 년/월/01 선택되도록
        var cellIndex: Int = (year * 10000) + (month * 100) + 1
        
        // 오늘 년/월 구하기
        let thisYear: (year:Int, month:Int) = CalendarManager.getYearMonth(amount: 0)
        // 이번달 일때 오늘 날짜로 선택해준다.
        if thisYear.year == year && thisYear.month == month {
            cellIndex = CalendarManager.getTodayIndex()
        }
        
        // 셀선택
		if CalendarManager.isChangeSelectedCell == false {
			CalendarManager.setSelectedCell(selectedCell: cellIndex)
		}
		
		CalendarManager.isChangeSelectedCell = false
		
        let selectYMD = "\(CalendarManager.selectedCell)"
		
        // 콜렉션에 맞는 날짜 전달
        selectedDate = String(format: "%04d%02d%@", year, month, selectYMD.right(2))
        self.todoListDateLabel.text = CalendarManager.todolistDateText
        selectedDayTodoList(doReload: true)
    }
    
    // 이번달 이동
    func goThisMonth(_ dicResult: [String: Any] = [:]) {
        // 셀선택
		CalendarManager.setSelectedCell(selectedCell: -1)
		
        // 달력날짜 시작/종료일 세팅
        var dicRetResult: [String: Any]
        
        // 전달받은 데이터가 없으면 이번달 기준으로 새로 데이터를 구하기
        if dicResult.isEmpty == true {
            dicRetResult = CalendarManager.getYearMontLimite(startYYYYMMDD: startYYYYMMDD, endYYYYMMDD: endYYYYMMDD)
        }
        else {
            dicRetResult = dicResult
        }
        
        // 보여줄 년/월일 목록
        let arrResultMonths: [(year:Int, month:Int)]? = dicRetResult["arrResultMonths"] as? [(year: Int, month: Int)]
        guard let arrResult = arrResultMonths else {
            return
        }
        
        // 보여줄 콜렉션뷰 초기화
        arrChildController.removeAll()
        // 스크롤 서브페이지 초기화
        scrollView.removeAllSubCell()
        self.focusIndex = dicRetResult["focusIndex"] as! Int
        for i in 0..<arrResult.count {
            let newYearMonth: (year:Int, month:Int) = arrResult[i]
            let monthVC = self.arrOriginController[i]
            
            // 스크롤뷰에 SubCell 추가
            scrollView.addScrollSubview(monthVC.view)
            arrChildController.append(monthVC)
            
            monthVC.setMonthToDays(year: newYearMonth.year, month: newYearMonth.month)
            
            // 포커스 페이지면...
            if focusIndex == i {
                self.curentDate = newYearMonth
            }
            
            // 혹시 3개가 인경우 더이상 처리하지 않는다.
            if arrChildController.count == 3 {
                break
            }
        }
        
        // 서브셀 위치 재설정
        scrollView.reposSubCell()
        
        // 포커스 페이지 이동 시킨다.
        self.scrollView.goFocusPageMove(focusIndex: focusIndex)
        
        // 달력 타이틀 세팅
        setCalendarTitle(centerIndex: focusIndex)
        
        self.scrollDirection = 0
        
        // 기본 선택 날짜
        defaultSelectDate(year: self.curentDate.year, month: self.curentDate.month)
    }
    
    // 달력 타이틀 세팅
    func setCalendarTitle(centerIndex: Int = -1) {
        let title = String(format: "%d년 %02d월", self.curentDate.year, self.curentDate.month)
        btnCalendarTitle.setTitle(title, for: .normal)
        
        let monthVC: CalendarMonthViewController? = arrChildController[centerIndex == -1 ? scrollView.centerIndex : centerIndex]
        if monthVC != nil {
            let scrollHeight: CGFloat = CGFloat(monthVC!.cellLineCount) * 55.0
            // -1은 라인 굵기
            todoListHeightConstraint.constant = vContent.bounds.height - scrollHeight - 1
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
            
            //            print("전체높이 = \(vContent.bounds.height - scrollHeight)")
        }
    }
    
    // 이전 페이지 이동시 처리
    func goPrevPage(year:Int, month:Int) {
        
        var newYear = year
        var newMonth = month
        
        newMonth -= 1
        if newMonth == 0 {
            newYear -= 1
            newMonth = 12
        }
        
        // 월별뷰컨트롤러 배열 재정렬
        let monthVC: CalendarMonthViewController? = self.arrChildController.popLast()
        self.arrChildController.insert(monthVC!, at: 0)
        monthVC?.setMonthToDays(year: newYear, month: newMonth)
        
        // 이전 페이지 이동시 처리
        scrollView.goPrevPage()
        
        // 달력 타이틀 세팅
        setCalendarTitle()
    }
    
    // 다음 페이지 이동시 처리
    func goNextPage(year:Int, month:Int) {
        var newYear = year
        var newMonth = month
        
        newMonth += 1
        if newMonth == 13 {
            newYear += 1
            newMonth = 1
        }
        
        // 월별뷰컨트롤러 배열  재정렬
        let monthVC = self.arrChildController.removeFirst()
        self.arrChildController.append(monthVC)
        monthVC.setMonthToDays(year: newYear, month: newMonth)
        
        // 다음 페이지 이동시 처리
        scrollView.goNextPage()
        
        // 달력 타이틀 세팅
        setCalendarTitle()
    }
    
    // 현재달력에서 이전달 선택시 이전달로 스크롤링
    func goPrevPageScrollAnimation() {
        let tabIndex: Int = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if tabIndex == 0 {
			// 이전, 다음달 날짜 선택
			CalendarManager.isChangeSelectedCell = false

            return
        }
        
        let offsetX = CGFloat(tabIndex - 1) * scrollView.bounds.width
        let leftOffset = CGPoint(x: offsetX, y: 0)
        
        self.scrollView.setContentOffset(leftOffset, animated: true)
        self.perform(#selector(self.scrollViewDidEndDecelerating(_:)), with: scrollView, afterDelay: 0.5)
    }
    
    // 현재달력에서 다음달 선택시 다음달로 스크롤링
    func goNextPageScrollAnimation() {
        let tabIndex: Int = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if tabIndex == (arrChildController.count - 1) {
			// 이전, 다음달 날짜 선택
			CalendarManager.isChangeSelectedCell = false

            return
        }
        
        let offsetX = CGFloat(tabIndex + 1) * scrollView.bounds.width
        let rightOffset = CGPoint(x: offsetX, y: 0)
        
        self.scrollView.setContentOffset(rightOffset, animated: true)
        self.perform(#selector(self.scrollViewDidEndDecelerating(_:)), with: scrollView, afterDelay: 0.5)
    }
    
    // 날짜에 맞는 TodoList 불러오기
    func selectedDayTodoList(doReload: Bool = false) {
        
//        if self.isHide { // 체크한 todo를 보여주지 않을 때
//            self.todoArray = DBManager.sharedInstance.selectTodoDB(withoutCheckedBox: true)
//        } else { // 체크한 todo를 보여줄 때
//            self.todoArray = DBManager.sharedInstance.selectTodoDB()
//        }
        
        if self.isHide { // 체크한 todo를 보여주지 않을 때
            self.selectedDayTodo = DBManager.shared.selectTodoDB(seletedDate: self.selectedDate!, withoutCheckedBox: true)
        } else { // 체크한 todo를 보여줄 때
            self.selectedDayTodo = DBManager.shared.selectTodoDB(seletedDate: self.selectedDate!)
        }
        
//        self.selectedDayTodo.removeAll()
//        for todo in self.todoArray {
//            if todo.date == self.selectedDate {
//                if !todo.isDeleted! { // 삭제한 것을 제외한 나머지만 추가
//                    self.selectedDayTodo.append(todo)
//                }
//            }
//        }
        
        if self.selectedDayTodo.isEmpty { // todo가 없다면
            self.isEmptyTodoList(isEmpty: true)
        } else {
            self.isEmptyTodoList(isEmpty: false)
        }
        
        if doReload { // doReload가 true라면
            self.todoTableView.reloadData()
        }
    }
    
    // todo가 없으면 일정 없음 이미지 띄워주기
    func isEmptyTodoList(isEmpty: Bool) {
        if isEmpty { // todo가 없으면
			// sama73 : todo list 헤더 높이 세팅
			// todo list 데이터가 있으나 전체 숨김 처리가 된경우.
			self.emptyTodoListView.isHidden = false // 일정 없음 이미지 띄우기
			
			if CalendarManager.todolistCount != 0 {
				self.todoListHeaderHeightConstraint.constant = 53.0
				
				self.vHiddenMessage.isHidden = false // 일정 없음 이미지 띄우기
				self.vEmptyMessage.isHidden = true // 일정 없음 이미지 띄우기
			}
			// todo list 데이터가 아예 없을 때...
			else {
				self.todoListHeaderHeightConstraint.constant = 0.0
				
				self.vHiddenMessage.isHidden = true // 일정 없음 이미지 띄우기
				self.vEmptyMessage.isHidden = false // 일정 없음 이미지 띄우기
			}
			
//            self.fixedTodoListInfoView.isHidden = true
            self.todoTableView.isHidden = true
        } else {
			// todo list 헤더 높이 세팅
			self.todoListHeaderHeightConstraint.constant = 53.0
            self.emptyTodoListView.isHidden = true // 일정 없음 이미지 띄우기
            
//            self.fixedTodoListInfoView.isHidden = false
            self.todoTableView.isHidden = false
        }
    }
	
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - UIButton Action
    // 사이드 메뉴
    @IBAction func onMenuClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    // 오늘 날짜
    @IBAction func onTodayClick(_ sender: Any) {
        // 이번달 이동
        goThisMonth()

        self.selectedDate = Date().cmpString()
        self.selectedDayTodoList(doReload: true)
    }
    
    // 년월 선택
    @IBAction func onYYYYMMClick(_ sender: Any) {
		
		var startYYYYMM: String = "\(startYYYYMMDD/100)"
		let endYYYYMM: String = "\(endYYYYMMDD/100)"
		let minYYYYMM: Int = Int(startYYYYMMDD/100)
		let maxYYYYMM: Int = Int(endYYYYMMDD/100)
		let curYYYYMM: Int = curentDate.year * 100 + curentDate.month

		let year: Int = Int(startYYYYMM.left(4))!
		let month: Int = Int(startYYYYMM.mid(4, amount: 2))!
		var count = 0

		var arrData: [Int] = []

		repeat {
			let dateNext = CalendarManager.getYearMonth(year: year, month: month, amount: count)
			startYYYYMM = String(format: "%d%02d", dateNext.year, dateNext.month)

			arrData.append(dateNext.year * 100 + dateNext.month)

			count += 1
		} while startYYYYMM != endYYYYMM
		
		let popup = YearMonthPopup.yearMonthPopup(curYYYYMM: curYYYYMM, minYYYYMM: minYYYYMM, maxYYYYMM: maxYYYYMM)
		popup.addActionConfirmClick { (curYYYYMM) in
			
			// 기본 3페이지 중간 페이지를 보여준다.
			var focusIndex: Int = 1
			var startIndex: Int = -1
			
			// 선택한 년/월 인덱스 구하기
			var selectedCount: Int = -1
			
			for i in 0..<arrData.count {
				let YYYYMM = arrData[i]
				if YYYYMM == curYYYYMM {
					selectedCount = i
					break
				}
			}
			
			if selectedCount == 0 {
				focusIndex = 0
				startIndex = 0
			}
			else if selectedCount == (arrData.count - 1) {
				focusIndex = 2
				startIndex = selectedCount - 2
			}
			else {
				startIndex = selectedCount - 1
			}
			
			if startIndex < 0 {
				focusIndex = 0
				startIndex = 0
			}
			
			// 반환해줄 목록
			var dicResult = [String: Any]()
			
			// 보여줄 년/월일 목록
			var arrResultMonths = [(year:Int, month:Int)]()
			
			for i in startIndex..<arrData.count {
				let YYYYMM = arrData[i]
				let year: Int = YYYYMM / 100
				let month: Int = YYYYMM % 100
				
				arrResultMonths += [(year, month)]
				if arrResultMonths.count == 3 {
					break
				}
			}
			
			dicResult["focusIndex"] = focusIndex
			dicResult["arrResultMonths"] = arrResultMonths
			
			// 이번달 이동
			self.goThisMonth(dicResult)
		}
    }
	
	// 추가 버튼
	@IBAction func onAddClick() {
		// sama73 : Todo 테이터 추가
		var dicConfig: [String: Any] = [:]
		dicConfig["TITLE"] = CalendarManager.todolistDateText
		dicConfig["MESSAGE"] = ""
		dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.default
		
		let popup = TodoListAddPopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick { (message) in
			if (message?.isEmpty)! { // 메세지 값이 비었다면 리턴처리
				return
			}
			
			// 새로운 Todo 추가
			let uid = UUID().uuidString
			let title = message
			let date = self.selectedDate
			
			let todo = ModelTodo(uid: uid, title: title!, date: date!)
			self.todoArray.append(todo)
			
			DBManager.shared.addTodoDB(todo: todo)
			
			self.selectedDayTodoList(doReload: true)
			
			// sama73 : 화면 재갱신
			self.setDBReloadData()
		}
		
		popup.addActionCancelClick {
			
		}
	}

    // 스위치 클릭 했을 때 처리
    @IBAction func switchClick(_ sender: UISwitch) {
        if self.isHide { // hide 상태일 때, show를 누를 경우
            self.ud.setValue(false, forKey: "isHide")
            ud.synchronize()
            self.isHide = false
        } else { // show 상태일 때, hide를 누르는 경우
            self.ud.setValue(true, forKey: "isHide")
            ud.synchronize()
            self.isHide = true
        }
        
        self.selectedDayTodoList(doReload: true)
    }
}

extension MonthlyPlanViewController: UIScrollViewDelegate {
    
    // 스크롤 뷰에서 내용 스크롤을 시작할 시점을 대리인에게 알립니다.
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging:")
        
    }
    
    // 2. 스크롤뷰가 스크롤 된 후에 실행된다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 무한스크롤뷰 일때
        if scrollView is InfiniteScrollView {
            // 수직 스크롤링 고정
            scrollView.contentOffset.y = 0.0
            
            let tabIndex: CGFloat = scrollView.contentOffset.x / scrollView.bounds.width
            let curentIndex: Int = Int(tabIndex)
            
            let infiniteScroll: InfiniteScrollView = scrollView as! InfiniteScrollView
            
            // 페이지 이동 가능한지 체크
            if infiniteScroll.isScrollable() == false {
                return
            }
            
            // 센터 달력
            let monthlyPlanVC: CalendarMonthViewController? = arrChildController[curentIndex]
            if let monthVC = monthlyPlanVC {
                // Prev Move
                if tabIndex <= infiniteScroll.prevPageIndex() {
                    // 좌측 스크롤
                    self.scrollDirection = -1
                    
                    if (monthVC.curentYear * 100 + monthVC.curentMonth) > (startYYYYMMDD/100) {
                        self.goPrevPage(year: monthVC.curentYear, month: monthVC.curentMonth)
                        
                        return
                    }
                }
                    // Next Move
                else if tabIndex >= infiniteScroll.nextPageIndex() {
                    // 마지막페이지에서 넘어설 경우만 체크
                    if tabIndex > CGFloat(CGFloat(self.arrChildController.count)-1.0) {
                        // 우측 스크롤
                        self.scrollDirection = 1
                    }
                    
                    if (monthVC.curentYear * 100 + monthVC.curentMonth) < (endYYYYMMDD/100) {
                        self.goNextPage(year: monthVC.curentYear, month: monthVC.curentMonth)
                        
                        return
                    }
                }
                
                // 달력 타이틀 세팅
                //                self.curentDate = (monthVC.curentYear, monthVC.curentMonth)
                //                setCalendarTitle(centerIndex: curentIndex)
            }
        }
    }
    
    // 드래그가 스크롤 뷰에서 끝났을 때 대리자에게 알립니다.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging:willDecelerate:")
        
    }
    
    // (현재 못씀)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
        
    }
    
    // 스크롤뷰가 Touch-up 이벤트를 받아 스크롤 속도가 줄어들때 실행된다.
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        
    }
    
    // 스크롤 애니메이션의 감속 효과가 종료된 후에 실행된다.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 무한스크롤뷰 일때
        if scrollView is InfiniteScrollView {
            let tabIndex: CGFloat = scrollView.contentOffset.x / scrollView.bounds.width
            
            // 마지막페이지에서 한번더 댕겼을 경우 상세페이지 이동
            if self.scrollDirection == 1 {
                if focusIndex == (self.arrChildController.count-1) {
                    
                    let YYYYMMDD: String = "\(startYYYYMMDD)"
                    let year: Int = Int(YYYYMMDD.left(4))!
                    let month: Int = Int(YYYYMMDD.mid(4, amount: 2))!
                    let day: Int = Int(YYYYMMDD.right(2))!
                    
                    // 다음페이지 이동
                    let storyboard = UIStoryboard.init(name: "DiaryPage", bundle: nil)
                    let diaryPage:PageController = storyboard.instantiateInitialViewController() as! PageController
					diaryPage.isMenuButtonShow = false
                    
                    // sama73 : 날짜 변환
                    var dateComponents = DateComponents()
                    dateComponents.year = year
                    dateComponents.month = month
                    dateComponents.day = day
                    
                    let calendar = Calendar(identifier: .gregorian)
                    let date: Date? = calendar.date(from: dateComponents)
                    diaryPage.currentDate = date!
                    self.navigationController?.pushViewController(diaryPage, animated: true)
                }
            }
            
            // 스크롤 셀 포커스 인덱스
            self.focusIndex = Int(tabIndex)
            
            // 스크롤 방향 초기화
            self.scrollDirection = 0
            
            //        print("focusIndex=\(focusIndex)")
            let monthVC: CalendarMonthViewController? = self.arrChildController[self.focusIndex]
            if let monthVC = monthVC {
                if monthVC.curentYear != curentDate.year || monthVC.curentMonth != curentDate.month {
                    // 달력 타이틀 세팅
                    self.curentDate = (monthVC.curentYear, monthVC.curentMonth)
                    setCalendarTitle(centerIndex: self.focusIndex)
                    
                    // 기본 선택 날짜
                    defaultSelectDate(year: self.curentDate.year, month: self.curentDate.month)
                }
            }
        }
    }
    
    // scrollView.scrollsToTop = YES 설정이 되어 있어야 아래 이벤트를 받을수 있다.
    // 스크롤뷰가 가장 위쪽으로 스크롤 되기 전에 실행된다. NO를 리턴할 경우 위쪽으로 스크롤되지 않도록 한다.
    //- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
    //{
    //    NSLog(@"scrollViewShouldScrollToTop");
    //    return YES;
    //}
    
    // 스크롤뷰가 가장 위쪽으로 스크롤 된 후에 실행된다.
    //- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
    //{
    //    NSLog(@"scrollViewDidScrollToTop");
    //}
    
    // 사용자가 콘텐츠 스크롤을 마쳤을 때 대리인에게 알립니다.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging:withVelocity:targetContentOffset:")
        
    }
}


// MARK:- TableView 관련
// TableViewDataSource
extension MonthlyPlanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedDayTodo.count * 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 { // 홀수번째 셀 (공백)
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") as! BlankCell
            return cell
        }
        
        let indexRow = indexPath.row / 2 // 0, 2, 4 ... 데이터를 표시할 셀
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        // view 테두리 둥글게 처리
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.masksToBounds = true
        
        let todo = self.selectedDayTodo[indexRow] // 짝수 번째 셀 : todo , 홀수 번째 셀 : 공백
        
        // 현재 타이틀의 포인트를 가져온다.
        let fontSize = cell.titleLabel.font.pointSize
        // attributeText에 font를 적용한 Text를 넣는다.
        cell.titleLabel.attributedText = FontManager.shared.getTextWithOnlyFont(text: todo.title!, size:fontSize)
        //cell.titleLabel.text = todo.title
        
        cell.checkBox.boxType = .circle
        cell.checkBox.delegate = self
        cell.checkBox.tag = indexRow
        if todo.isSelected! { // 체크박스에 체크가 되어있다면
            cell.checkBox.setOn(true, animated: true)
            cell.titleLabel.textColor = UIColor.lightGray
			cell.cellView.backgroundColor = UIColor(hex: 0xFBFBFB)
        } else { // 체크박스에 체크가 되어있지 않다면
            cell.checkBox.setOn(false, animated: true)
            cell.titleLabel.textColor = UIColor.black
			cell.cellView.backgroundColor = UIColor(hex: 0xFFFFFF)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 { // todoCell 높이
            return 60
        } else { // 공백 셀 높이
            return 10
        }
    }
/*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let indexRow = index.row / 2 // 공백 셀 때문에 실질적으로 0,2,4... 셀이 데이터 셀이다
            let todo = self.selectedDayTodo[indexRow]
            
            DBManager.sharedInstance.deleteTodoDB(todo: todo) {
                self.selectedDayTodo.remove(at: indexRow)
            }
            
            // 테이블뷰 갱신
            self.selectedDayTodoList(doReload: true)
            
            // sama73 : 화면 재갱신
            self.setDBReloadData()
        }
        
        return [deleteButton]
    }
*/
}



// TableViewDelegate
extension MonthlyPlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // sama73 : 테이블뷰셀 선택 해제
        tableView.deselectRow(at: indexPath, animated: false)
        
        let todo = selectedDayTodo[indexPath.row / 2]
        
        // sama73 : Todo 테이터 수정
        var dicConfig: [String: Any] = [:]
        dicConfig["TITLE"] = CalendarManager.todolistDateText
        dicConfig["MESSAGE"] = todo.title
        dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.default
        
        let popup = TodoListAddPopup.messagePopup(dicConfig: dicConfig)
		popup.addActionConfirmClick { (message) in
			if (message?.isEmpty)! { // 메세지 값이 비었다면 리턴처리
				return
			}
			
			todo.title = message
			DBManager.shared.updateTodo(todo: todo)
			self.selectedDayTodoList(doReload: true)
		}
		
		popup.addActionCancelClick {
			
		}
    }
	
	// 스와이프 delete 액션 세팅
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete])
	}
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			let indexRow = indexPath.row / 2 // 공백 셀 때문에 실질적으로 0,2,4... 셀이 데이터 셀이다
			let todo = self.selectedDayTodo[indexRow]
			
			DBManager.shared.deleteTodoDB(todo: todo) {
				self.selectedDayTodo.remove(at: indexRow)
			}
			
			// 테이블뷰 갱신
			self.selectedDayTodoList(doReload: true)
			
			// sama73 : 화면 재갱신
			self.setDBReloadData()

			completion(true)
		}
		action.image = UIImage(named: "icon_cell_delete")
		action.backgroundColor = UIColor(hex: 0x929292)
		
		return action
	}
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row % 2 == 0 { // 짝수번째 셀은 delete 허용
            return true
        } else {
            return false
        }
    }
}



// BEMCheckBoxDelegate
extension MonthlyPlanViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        let todo = self.selectedDayTodo[checkBox.tag]
        if checkBox.on {
            todo.isSelected = true
        } else {
            todo.isSelected = false
        }
        
        DBManager.shared.updateTodo(todo: todo)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.selectedDayTodoList(doReload: true)
    }
}

class TodoCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var checkBox: BEMCheckBox!
    @IBOutlet var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectionStyle = .none
        
        //        // 셀의 밑줄을 그린다
        //        self.layer.addBorder([.bottom], color: UIColor.darkGray, width: 0.3)
    }
}


class BlankCell: UITableViewCell {
    
}




