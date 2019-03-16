//
//  CalendarMonthViewController.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "CalendarDayCell"

class CalendarMonthViewController: UICollectionViewController, UIGestureRecognizerDelegate {

	// 부모VC
	var parentVC:MonthlyPlanViewController?
    // 셀라인갯수
    var cellLineCount:Int = 0
	// 선택한 년/월
	var curentYear: Int = 2019
	var curentMonth: Int = 1
    // 셀 갯수
    var arrDays:[[String: Any]]?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // UICollectionViewCell Long Press Event
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
    }
	
	// 설정할 년/월 재갱신
	func setDBReloadData() {
		setMonthToDays(year: curentYear, month: curentMonth, isRequest: false)
	}
	
    // 설정할 년/월
    func setMonthToDays(year:Int, month:Int, isRequest:Bool = true) {
        print("년월 = \(year) - \(month)")
		
		// 선택한 년/월
		curentYear = year
		curentMonth = month

        // 년/월에 맞는 날짜 목록 얻어오기
        arrDays = CalendarManager.getMonthToDays(year:year, month:month)
        cellLineCount = Int((arrDays?.count)! / 7)
        self.collectionView.reloadData()
        
        if isRequest == true {
            // 공휴일 체크
            self.requestHoliday(year: curentYear, month: curentMonth)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.arrDays == nil {
            return 0
        }
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.arrDays == nil {
            return 0
        }
        
        return self.arrDays!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: CalendarDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        if let arrDays = self.arrDays {
            let item = arrDays[indexPath.row]
            cell.setCellInfo(item)
            // Configure the cell
            //            cell.lbDay.text = "\(strValue)-\(indexPath.row+1)"
        }
        
        return cell
    }
    
    // MARK: - UIGestureRecognizerDelegate
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
		let cellPathIndex: NSIndexPath? = (self.collectionView.indexPathForItem(at: p)! as NSIndexPath)
		guard let indexPath = cellPathIndex else {
            return
        }
        
        //do whatever you need to do
        let item: [String: Any] = arrDays![indexPath.row]
        let year: Int = item["year"] as! Int
        let month: Int = item["month"] as! Int
        let day: Int = item["day"] as! Int
        let cellIndex: Int = item["cellIndex"] as! Int
        
        // 다음페이지 이동
        /*
		let storyboard = UIStoryboard.init(name: "DiaryPage", bundle: nil)
		let diaryPage:PageController = storyboard.instantiateInitialViewController() as! PageController
		diaryPage.isMenuButtonShow = false
		*/
        //let diary:DiaryViewController = UIStoryboard.init(name: "DiaryPage", bundle: nil).instantiateViewController(withIdentifier: "Diary") as! DiaryViewController
        let diary:DiaryViewController = DiaryViewController.GetController(storyboard: "DiaryPage", identifier: "Diary") as! DiaryViewController
        
        
		// sama73 : 날짜 변환
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		
		let calendar = Calendar(identifier: .gregorian)
		let date: Date? = calendar.date(from: dateComponents)
		//diaryPage.currentDate = date!
        //print("self.navigationController?.pushViewController(diaryPage, animated: true)")
		//self.navigationController?.pushViewController(diaryPage, animated: true)
        self.navigationController?.pushViewController(diary, animated: true)
        
        // 셀선택
		CalendarManager.setSelectedCell(selectedCell: cellIndex)
		
        // 콜렉션뷰 전체 리로드
        parentVC?.collectionReloadDataAll()
    }
    
    // MARK: - RESTfull API
    // 공휴일 체크
    func requestHoliday(year:Int, month:Int) {
        // 체크기간 유효성 체크
        // 공공데이터 포털에서 2015.01 ~ 올해 12월까지만 검색 가능하다.

        // 오늘 년/월 구하기
        let thisYear: (year:Int, month:Int) = CalendarManager.getYearMonth(amount: 0)

        // 선택한 년/월 인덱스
        let curIndex = year * 100 + month
        // 올해 마지막
        let maxIndex = thisYear.year * 100 + 12
        if curIndex < 201501 || curIndex > maxIndex {
            return
        }
        
        // RelamDB에서 먼저 검색해보고 없으면 API
        // 공휴일 정보 검색
        let sql = "SELECT * FROM ModelDBHoliday WHERE dateYYYYMM=\(curIndex);"
        // SQL 결과
        let dicSQLResults:[String: Any] = DBManager.SQLExcute(sql: sql)
        let resultCode: String = dicSQLResults["RESULT_CODE"] as! String
        // 검색 실패
        if resultCode != "0" {
            return
        }

        // 해당 년/월에 데이터가 저장되어 있으면...
        let resultData: Results<Object> = dicSQLResults["RESULT_DATA"] as! Results<Object>
        if resultData.count > 0 {
            return
        }
        
        // 공공데이터 포털 API호출
        var param: [String: Any] = AlamofireHelper.requestParameters()        
        param["ServiceKey"] = kServiceKey_AUTHKEY
        param["solYear"] = "\(year)"
        param["solMonth"] = String(format: "%02d", month)
//        param["_type"] = "json"

        // 로더 비활성화
        param["isNotShowLoader"] = true
        print(param)
        
        AlamofireHelper.requestGET(kMonthHoliday_URL, parameters: param, success: { (jsonData) in
            
            guard let jsonData = jsonData else {
                return
            }
            
            print(jsonData)
            let response: [String: Any]? = (jsonData["response"] as! [String : Any])
            if CommonUtil.isEmpty(response as AnyObject) { return }
            
            let body: [String: Any]? = response!["body"] as? [String : Any]
            if CommonUtil.isEmpty(body as AnyObject) { return }
            
            let totalCount: Int = body!["totalCount"] as? Int ?? 0
            if totalCount == 0 {
				// dateYYYYMMDD필드가 프라이머리키인데 데이터 자체가 없을때는 'YYYYMM'값을 프라이머리키필드에 세팅해준다.
                // RelamDB INSERT문
                var sql = "INSERT INTO ModelDBHoliday(dateYYYYMM, "
                sql += "dateYYYYMMDD, "
                sql += "name) VALUES('\(curIndex)', "
                sql += "'\(curIndex)', "
                sql += "'');"
                
                // SQL 결과
                DBManager.SQLExcute(sql: sql)
            }
            // 딕셔너리
            else if totalCount == 1 {
                let items: [String: Any]? = body!["items"] as? [String : Any]
                if CommonUtil.isEmpty(items as AnyObject) { return }
                
                let item: [String: Any]? = items!["item"] as? [String: Any]
                if CommonUtil.isEmpty(item as AnyObject) { return }
                
                let dateName: String = item!["dateName"] as! String
                let locdate: Int = item!["locdate"] as! Int
                print("dateName = \(dateName), locdate = \(locdate)")
                
                // RelamDB INSERT문
                var sql = "INSERT INTO ModelDBHoliday(dateYYYYMM, "
                sql += "dateYYYYMMDD, "
                sql += "name) VALUES('\(curIndex)', "
                sql += "'\(locdate)', "
                sql += "'\(dateName)');"
                
                // SQL 결과
                DBManager.SQLExcute(sql: sql)
                
                // 설정할 년/월 갱신
                self.setMonthToDays(year: self.curentYear, month: self.curentMonth, isRequest: false)
            }
            // 배열
            else {
                let items: [String: Any]? = body!["items"] as? [String : Any]
                if CommonUtil.isEmpty(items as AnyObject) { return }
                
                let item: [[String: Any]]? = items!["item"] as? [[String: Any]]
                if CommonUtil.isEmpty(item as AnyObject) { return }
                
                for holiday:[String: Any] in item! {
                    let dateName: String = holiday["dateName"] as! String
                    let locdate: Int = holiday["locdate"] as! Int
                    print("dateName = \(dateName), locdate = \(locdate)")
                    
                    // RelamDB INSERT문
                    var sql = "INSERT INTO ModelDBHoliday(dateYYYYMM, "
                    sql += "dateYYYYMMDD, "
                    sql += "name) VALUES('\(curIndex)', "
                    sql += "'\(locdate)', "
                    sql += "'\(dateName)');"
                    
                    // SQL 결과
                    DBManager.SQLExcute(sql: sql)
                }
                
                // 설정할 년/월 갱신
                self.setMonthToDays(year: self.curentYear, month: self.curentMonth, isRequest: false)
            }
        }) { (error) in
            print(error!)
        }
    }
}

extension CalendarMonthViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 53.0, height: 55.0)
    }

    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 0.0
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return 0.0
     }
     */
    
    // 셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
		let item: [String: Any] = arrDays![indexPath.row]

        let year: Int = item["year"] as! Int
        let month: Int = item["month"] as! Int
        let day: Int = item["day"] as! Int
        let cellIndex: Int = item["cellIndex"] as! Int
        let monthDirection: Int = item["monthDirection"] as! Int

		// 셀선택
		CalendarManager.setSelectedCell(selectedCell: cellIndex)

        // 현재달력에서 이전달 선택시 이전달로 스크롤링
        if monthDirection == -1 {
			// 이전, 다음달 날짜 선택
			CalendarManager.isChangeSelectedCell = true
			
            parentVC?.goPrevPageScrollAnimation()
        }
        // 현재달력에서 다음달 선택시 다음달로 스크롤링
        else if monthDirection == 1 {
			// 이전, 다음달 날짜 선택
			CalendarManager.isChangeSelectedCell = true
			
            parentVC?.goNextPageScrollAnimation()
        }
		else {
			// 셀선택
//			CalendarManager.setSelectedCell(selectedCell: cellIndex)
			
			// 콜렉션뷰 전체 리로드
			parentVC?.collectionReloadDataAll()

			// 콜렉션에 맞는 날짜 전달
			parentVC?.selectedDate = String(format: "%04d%02d%02d", year, month, day)
			parentVC?.selectedDayTodoList(doReload: true)
            parentVC?.todoListDateLabel.text = CalendarManager.todolistDateText
		}
    }
}
