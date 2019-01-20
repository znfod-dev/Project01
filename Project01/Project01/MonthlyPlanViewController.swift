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
    var arrChildController = [CalendarMonthViewController]()
	
	// sama73: 시작일/종료일 샘플
	var startYYYYMMDD = 20181101
	var endYYYYMMDD = 20190301
	
	// 다이어리 상세
	var isDiaryDetail: Bool = false
	
	// 이전 보여주는 페이지
	var oldCurentIndex: Int = -1
    
    // 선택한 년/월
    var curentYear: Int = 2019
    var curentMonth: Int = 1
    
    // 테이블 뷰
    var todoArray = Array<Todo>() // 전체 TodoList
    var selectedDayTodo = Array<Todo>() // 특정 날짜의 TodoList
    
    var selectedDay:String? = Date().string() // 선택한 날짜
    
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
        let yearMonth:(year:Int, month:Int) = CalendarManager.getYearMonth(amount: 0)
        curentYear = yearMonth.year
        curentMonth = yearMonth.month
		
		// 매월 셀 세팅해서 추가해주기
		if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
			for _ in 0..<3 {
				if let monthVC: CalendarMonthViewController = (storyboard.instantiateViewController(withIdentifier: "CalendarMonthViewController") as? CalendarMonthViewController) {
					monthVC.parentVC = self
                    monthVC.view.frame = scrollView.bounds
					
					// 스크롤뷰에 새로 추가
					scrollView.addScrollSubview(monthVC.view)
					self.addChild(monthVC)
                    // 월별뷰컨트롤러 배열
                    self.arrChildController.append(monthVC)
				}
			}
			
			// 이번달 이동
			goThisMonth()
		}
        
        if self.isHide { // Hide 상태라면 hide버튼을 show로 변경
        self.hideBtn.setTitle("show", for: .normal)
        }
        
        // 오늘 날짜로 선택날짜 TodoList에 넣기
        self.selectedDayTodoList()
		
		// 프로필 오너 DB체크
//		self.selectOwnerInfoTable()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// 다이어리 상세
		self.isDiaryDetail = false
	}
	
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
	
	// 콜렉션뷰 전체 리로드
	func collectionReloadDataAll() {
		for monthVC in self.arrChildController {
			monthVC.collectionView.reloadData()
		}
	}
	
	// 이번달 이동
	func goThisMonth() {
		// 오늘 년/월 구하기
		let yearMonth:(year:Int, month:Int) = CalendarManager.getYearMonth(amount: 0)
		curentYear = yearMonth.year
		curentMonth = yearMonth.month
		
		// 월별뷰컨트롤러 배열
		for i in 0..<arrChildController.count {
			let monthVC = self.arrChildController[i]
			
			var amount:Int = 0
			if i == 0 {
				amount = -1
			}
			else if i == 2 {
				amount = 1
			}
			
			let newYearMonth:(year:Int, month:Int) = CalendarManager.getYearMonth(year: curentYear, month: curentMonth, amount: amount)
			monthVC.setMonthToDays(year: newYearMonth.year, month: newYearMonth.month)
			print(newYearMonth)
		}
		
		// 서브셀 위치 재설정
		scrollView.reposSubCell()
		
		// 센터 페이지 이동 시킨다.
		self.scrollView.goCenterPageMove()
		
		// 달력 타이틀 세팅
		setCalendarTitle()
		
		// 다이어리 상세
		self.isDiaryDetail = false

		// 선택된 인덱스
		self.oldCurentIndex = -1
	}
	
	// 달력 타이틀 세팅
	func setCalendarTitle(centerIndex: Int = -1) {
		
		let monthTitle = CalendarManager.getMonthString(monthIndex: curentMonth)
		self.lbCalendarTitle.text = "\(monthTitle) \(curentYear)"
		
		let monthVC: CalendarMonthViewController? = arrChildController[centerIndex == -1 ? scrollView.centerIndex : centerIndex]
		if monthVC != nil {
			let scrollHeight: CGFloat = CGFloat(monthVC!.cellLineCount) * 60.0
			// -1은 라인 굵기
			todoListHeightConstraint.constant = vContent.bounds.height - scrollHeight - 1
			UIView.animate(withDuration: 0.1) {
				self.view.layoutIfNeeded()
			}
			
			//			print("전체높이=\(vContent.bounds.height - scrollHeight)")
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
        
        self.selectedDay = Date().string()
        self.selectedDayTodoList(doReload: true)
    }
    
    // 추가 버튼
    @IBAction func addClick(_ sender: Any) {
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
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    // 날짜에 맞는 TodoList 불러오기
    func selectedDayTodoList(doReload: Bool = false) {
        if self.isHide { // 체크 박스를 보여주지 않을 때
            self.todoArray = DBManager.sharedInstance.selectTodoDB(withoutCheckedBox: true)
        } else { // 체크 박스 까지 보여줄 때
            self.todoArray = DBManager.sharedInstance.selectTodoDB()
        }
        
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
    
    // MARK: - RealmDB SQL Excute
    // 프로필 오너 DB체크
    //    func selectOwnerInfoTable() {
    //
    //        // 오너 정보 검색
    //        let sql = "SELECT * FROM OwnerInfo WHERE uid='1';"
    //        // SQL 결과
    //        let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
    //        let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
    //        // 검색 성공
    //        if resultCode == "0" {
    //            let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
    //            // 오너 정보가 없을때...
    //            if resultData.count > 0 {
    //                return
    //            }
    //
    //            // 프로필 설정을 안했을 경우 한번은 띄워준다.
    //            if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
    //                if let profileVC: ProfileViewController = (storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController) {
    //                    self.present(profileVC, animated: true)
    //                }
    //            }
    //        }
    //    }
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
					if (monthVC.curentYear * 100 + monthVC.curentMonth) > (startYYYYMMDD/100) {
						self.goPrevPage(year: monthVC.curentYear, month: monthVC.curentMonth)
						
						return
					}
				}
					// Next Move
				else if tabIndex >= infiniteScroll.nextPageIndex() {
					if (monthVC.curentYear * 100 + monthVC.curentMonth) < (endYYYYMMDD/100) {
						self.goNextPage(year: monthVC.curentYear, month: monthVC.curentMonth)
						
						return
					}
					else {
						// 상세페이지 이동
						if oldCurentIndex == 2 && isDiaryDetail == false {
							isDiaryDetail = true
							
							let YYYYMMDD: String = "\(startYYYYMMDD)"
							let year: String = YYYYMMDD.left(4)
							let month: String = YYYYMMDD.mid(4, amount: 2)
							let day: String = YYYYMMDD.right(2)
							let popup = AlertMessagePopup.messagePopup(withMessage: "\(year)년\(month)월\(day)일 다이어리 상세페이지 이동")
							popup.addActionConfirmClick("확인", handler: {
								self.isDiaryDetail = false
							})
						}
					}
				}
				
				// 달력 타이틀 세팅
				curentYear = monthVC.curentYear
				curentMonth = monthVC.curentMonth
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
		// 이전 보여주는 페이지
		let tabIndex: CGFloat = scrollView.contentOffset.x / scrollView.bounds.width
		oldCurentIndex = Int(tabIndex)
		print("oldCurentIndex = \(oldCurentIndex)")
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
        
        cell.titleLabel.text = todo.title
        
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
        
        DBManager.sharedInstance.updateTodoIsSelectedDB(todo: todo)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.selectedDayTodoList(doReload: true)
    }
}



extension Date {
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMdd"
        let day = formatter.string(from: self)
        return day
    }
}
