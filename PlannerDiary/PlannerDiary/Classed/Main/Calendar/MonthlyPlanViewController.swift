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


class MonthlyPlanViewController: UIViewController {
	
	@IBOutlet var vWeekString: UIView!
	@IBOutlet weak var lbCalendarTitle: UILabel!
	@IBOutlet var vContent: UIView!
	@IBOutlet var scrollView: InfiniteScrollView!
	@IBOutlet var vHLine: UIView!
	@IBOutlet weak var todoListHeightConstraint: NSLayoutConstraint!
	
	// 월별뷰컨트롤러 배열
    var arrOriginController = [CalendarMonthViewController]()
    var arrChildController = [CalendarMonthViewController]()

	var startYYYYMMDD = 20181101
	var endYYYYMMDD = 20190301
	
	// 다이어리 상세
	var isDiaryDetail: Bool = false

    // 스크롤 Direction(-1: 좌측, 0: 정지, 1: 우측
    var scrollDirection: Int = 0

	// 이전 보여주는 페이지
	var focusIndex: Int = -1
	// 선택한 년/월
    var curentDate: (year:Int, month:Int) = (2019, 1)
    
    // 첫번째 이번달호출을 화면완료된후에 실행해줄려고
    var isFirstLoad: Bool = true
	
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
		}

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

        // 첫번째 이번달 호출시 화면 완료된 이후에 호출해준다.
        if isFirstLoad == true {
            isFirstLoad = false
            goThisMonth()
        }
	}
	
	// 콜렉션뷰 전체 리로드
	func collectionReloadDataAll() {
		for monthVC in self.arrChildController {
			monthVC.collectionView.reloadData()
		}
	}
	
	// 이번달 이동
    @objc func goThisMonth() {
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
		
		// 다이어리 상세
		self.isDiaryDetail = false
        
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
	}
	
	// MARK: - RealmDB SQL Excute
	// 프로필 오너 DB체크
	//	func selectOwnerInfoTable() {
	//
	//		// 오너 정보 검색
	//		let sql = "SELECT * FROM OwnerInfo WHERE uid='1';"
	//		// SQL 결과
	//		let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
	//		let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
	//		// 검색 성공
	//		if resultCode == "0" {
	//			let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
	//			// 오너 정보가 없을때...
	//			if resultData.count > 0 {
	//				return
	//			}
	//
	//			// 프로필 설정을 안했을 경우 한번은 띄워준다.
	//			if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
	//				if let profileVC: ProfileViewController = (storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController) {
	//					self.present(profileVC, animated: true)
	//				}
	//			}
	//		}
	//	}
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
			
//            print("contentOffset.x = \(scrollView.contentOffset.x) / bounds.width = \(scrollView.bounds.width)")
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
            if focusIndex == (self.arrChildController.count-1) && isDiaryDetail == false {
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
