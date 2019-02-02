//
//  MonthlyPlanViewController.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import SideMenuSwift
import RealmSwift
import BEMCheckBox


class MonthlyPlanViewController: UIViewController {
    
    @IBOutlet var vWeekString: UIView!
    @IBOutlet weak var lbCalendarTitle: UILabel!
    @IBOutlet var vContent: UIView!
    @IBOutlet var scrollView: InfiniteScrollView!
    @IBOutlet var vHLine: UIView!
    @IBOutlet weak var todoListHeightConstraint: NSLayoutConstraint!
    @IBOutlet var todoTableView: UITableView! // tableView
    @IBOutlet var hideBtn: UIButton!
    
    
    
    // 월별뷰컨트롤러 배열
    var arrOriginController = [CalendarMonthViewController]()
    var arrChildController = [CalendarMonthViewController]()
    
    // sama73: 시작일/종료일 샘플
    var startYYYYMMDD = 20181101
    var endYYYYMMDD = 20190301
    
    // 스크롤 Direction(-1: 좌측, 0: 정지, 1: 우측
    var scrollDirection: Int = 0
    
    // 이전 보여주는 페이지
    var focusIndex: Int = -1
    // 선택한 년/월
    var curentDate: (year:Int, month:Int) = (2019, 1)
    
    // 첫번째 이번달호출을 화면완료된후에 실행해줄려고
    var isFirstLoad: Bool = true
    
    // 테이블 뷰
    var todoArray = Array<Todo>() // 전체 TodoList
    var selectedDayTodo = Array<Todo>() // 특정 날짜의 TodoList
    
    var selectedDay:String? = Date().cmpString() // 선택한 날짜
    
    // 완료된 todo 숨기기
    // true : 체크 todo 숨기기
    // false : 모든 todo 보여주기
    var isHide: Bool = UserDefaults.standard.bool(forKey: "isHide")
    
    let ud = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        // 그림자 처리
        vWeekString.layer.shadowColor = UIColor.black.cgColor
        vWeekString.layer.shadowOffset = CGSize(width: 0, height: 1)
        vWeekString.layer.shadowOpacity = 0.1
        
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
                self.hideBtn.setTitle("show", for: .normal)
            }
            
            // 오늘 날짜로 선택날짜 TodoList에 넣기
            self.selectedDayTodoList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		// 시작 날짜, 마지막 날짜 변경 사항이 있으면 갱신해준다.
		let startDate = DBManager.sharedInstance.loadMinimumDateFromUD()
		let endDate = DBManager.sharedInstance.loadMaximumDateFromUD()
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier:"ko_KR")
		formatter.dateFormat = "yyyyMMdd"
		let startDate2 = formatter.string(from: startDate)
		let endDate2 = formatter.string(from: endDate)
		
		let start: Int = Int(startDate2)!
		let end: Int = Int(endDate2)!
		
		if startYYYYMMDD != start || endYYYYMMDD != end {
			startYYYYMMDD = start
			endYYYYMMDD = end
			
			print("startDate=\(startYYYYMMDD)")
			print("endDate=\(endYYYYMMDD)")

			goThisMonth()
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
    
    // 이번달 이동
    func goThisMonth() {
        // 셀선택
        CalendarManager.selectedCell = -1

        // 달력날짜 시작/종료일 세팅
        let dicResult: [String: Any] = CalendarManager.getYearMontLimite(startYYYYMMDD: startYYYYMMDD, endYYYYMMDD: endYYYYMMDD)
        print(dicResult)
        
        // 보여줄 년/월일 목록
        let arrResultMonths: [(year:Int, month:Int)]? = dicResult["arrResultMonths"] as? [(year: Int, month: Int)]
        guard let arrResult = arrResultMonths else {
            return
        }
        
        // 보여줄 콜렉션뷰 초기화
        arrChildController.removeAll()
        // 스크롤 서브페이지 초기화
        scrollView.removeAllSubCell()
        self.focusIndex = dicResult["focusIndex"] as! Int
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
    }
    
    // 달력 타이틀 세팅
    func setCalendarTitle(centerIndex: Int = -1) {
        
        let monthTitle = CalendarManager.getMonthString(monthIndex: self.curentDate.month)
        self.lbCalendarTitle.text = "\(monthTitle) \(self.curentDate.year)"
        
        let monthVC: CalendarMonthViewController? = arrChildController[centerIndex == -1 ? scrollView.centerIndex : centerIndex]
        if monthVC != nil {
            let scrollHeight: CGFloat = CGFloat(monthVC!.cellLineCount) * 60.0
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
			return
		}
		
		let offsetX = CGFloat(tabIndex + 1) * scrollView.bounds.width
		let rightOffset = CGPoint(x: offsetX, y: 0)
		
		self.scrollView.setContentOffset(rightOffset, animated: true)
		self.perform(#selector(self.scrollViewDidEndDecelerating(_:)), with: scrollView, afterDelay: 0.5)
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
        
        self.selectedDay = Date().cmpString()
        self.selectedDayTodoList(doReload: true)
    }
    
    // 추가 버튼
    @IBAction func addClick(_ sender: Any) {
        // sama73 : Todo 테이터 추가
        var dicConfig: [String: Any] = [:]
        dicConfig["TITLE"] = "Todo"
        dicConfig["MESSAGE"] = ""
        dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.default
        
        let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
        popup.addActionConfirmClick("추가") { (msg) in
            guard let message = msg else {
                return
            }
            
            // 새로운 Todo 추가
            let uid = UUID().uuidString
            let title = message
            let date = self.selectedDay
            
            let todo = Todo(uid: uid, title: title, date: date!)
            self.todoArray.append(todo)
            
            DBManager.sharedInstance.addTodoDB(todo: todo)
            
            self.selectedDayTodoList(doReload: true)
            
            // sama73 : 화면 재갱신
            self.setDBReloadData()
        }
        
        popup.addActionCancelClick("취소", handler: {
        })
/*
        let alert = UIAlertController(title: "Todo", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "save", style: .default, handler: { (_) in
            // 새로운 Todo 추가
            let uid = UUID().uuidString
            let title = alert.textFields?.last?.text
            let date = self.selectedDay
            
            let todo = Todo(uid: uid, title: title!, date: date!)
            self.todoArray.append(todo)
            
            DBManager.sharedInstance.addTodoDB(todo: todo)
            
            self.selectedDayTodoList(doReload: true)

			// sama73 : 화면 재갱신
			self.setDBReloadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alert, animated: true)
 */
    }
    
    
    // 날짜에 맞는 TodoList 불러오기
    func selectedDayTodoList(doReload: Bool = false) {
				
        if self.isHide { // 체크 박스를 보여주지 않을 때
            self.todoArray = DBManager.sharedInstance.selectTodoDB(withoutCheckedBox: true)
        } else { // 체크 박스 까지 보여줄 때
            self.todoArray = DBManager.sharedInstance.selectTodoDB()
        }
		
//		print(self.todoArray)
//		print(self.selectedDay)
        self.selectedDayTodo.removeAll()
        for todo in self.todoArray {
            if todo.date == self.selectedDay {
                self.selectedDayTodo.append(todo)
            }
        }
        
        if doReload { // doReload가 true라면
            self.todoTableView.reloadData()
        }
    }
    
    
    // 숨긴 버튼
    @IBAction func hideClick(_ sender: Any) {
        if self.isHide { // hide 상태일 때, show를 누를 경우
            self.hideBtn.setTitle("hide", for: .normal)
            self.ud.setValue(false, forKey: "isHide")
            ud.synchronize()
            self.isHide = false
        } else { // show 상태일 때, hide를 누르는 경우
            self.hideBtn.setTitle("show", for: .normal)
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
                self.curentDate = (monthVC.curentYear, monthVC.curentMonth)
                setCalendarTitle(centerIndex: curentIndex)
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
                let diaryPage:DiaryPageViewController = storyboard.instantiateInitialViewController() as! DiaryPageViewController
                
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
        
        print("focusIndex=\(focusIndex)")
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
        return self.selectedDayTodo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        let todo = self.selectedDayTodo[indexPath.row]
        
        // 현재 타이틀의 포인트를 가져온다.
        let fontSize = cell.titleLabel.font.pointSize
        // attributeText에 font를 적용한 Text를 넣는다.
        cell.titleLabel.attributedText = FontManager.shared.getTextWithOnlyFont(text: todo.title!, size:fontSize)
        //cell.titleLabel.text = todo.title
        
        cell.checkBox.boxType = .square
        cell.checkBox.delegate = self
        cell.checkBox.tag = indexPath.row
        if todo.isSelected! { // 체크박스에 체크가 되어있다면
            cell.checkBox.setOn(true, animated: true)
            cell.titleLabel.textColor = UIColor.lightGray
        } else { // 체크박스에 체크가 되어있지 않다면
            cell.checkBox.setOn(false, animated: true)
            cell.titleLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let todo = self.selectedDayTodo[indexPath.row]
            DBManager.sharedInstance.deleteTodoDB(todo: todo) {
                self.selectedDayTodo.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			
			// sama73 : 화면 재갱신
			self.setDBReloadData()
        }
    }
}



// TableViewDelegate
extension MonthlyPlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // sama73 : 테이블뷰셀 선택 해제
        tableView.deselectRow(at: indexPath, animated: false)
        
        let todo = selectedDayTodo[indexPath.row]

        // sama73 : Todo 테이터 수정
        var dicConfig: [String: Any] = [:]
        dicConfig["TITLE"] = "Todo 수정"
        dicConfig["MESSAGE"] = todo.title
        dicConfig["KEYBOARD_TYPE"] = UIKeyboardType.default
        
        let popup = PromptMessagePopup.messagePopup(dicConfig: dicConfig)
        popup.addActionConfirmClick("수정") { (message) in
            todo.title = message
            DBManager.sharedInstance.updateTodo(todo: todo)
            self.selectedDayTodoList(doReload: true)
        }
        
        popup.addActionCancelClick("취소", handler: {
        })
/*
        let alert = UIAlertController(title: "Todo 수정", message: nil, preferredStyle: .alert)
        
        let todo = selectedDayTodo[indexPath.row]
        alert.addTextField { (tf) in
            tf.text = todo.title
        }
        
        alert.addAction(UIAlertAction(title: "변경", style: .default, handler: { (_) in
            todo.title = alert.textFields?.last?.text
            DBManager.sharedInstance.updateTodo(todo: todo)
            self.selectedDayTodoList(doReload: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
 */
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
        
        DBManager.sharedInstance.updateTodo(todo: todo)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.selectedDayTodoList(doReload: true)
    }
}

class TodoCell: UITableViewCell {
    @IBOutlet var checkBox: BEMCheckBox!
    @IBOutlet var titleLabel: UILabel!
}




