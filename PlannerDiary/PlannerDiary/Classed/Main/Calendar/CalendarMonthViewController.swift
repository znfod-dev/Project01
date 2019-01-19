//
//  CalendarMonthViewController.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CalendarDayCell"

class CalendarMonthViewController: UICollectionViewController, UIGestureRecognizerDelegate {

	// 부모VC
	var parentVC:MonthlyPlanViewController?
    // 셀라인갯수
    var cellLineCount:Int = 0
    // 셀 갯수
    var arrDays:[(year:Int, month:Int, day:Int, cellIndex:Int, isCurentMonth:Bool)]?
	
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
    
    // 설정할 년/월
    func setMonthToDays(year:Int, month:Int) {
        print("년월 = \(year) - \(month)")
        
        // 년/월에 맞는 날짜 목록 얻어오기
        arrDays = CalendarManager.getMonthToDays(year:year, month:month)
        cellLineCount = Int((arrDays?.count)! / 7)
        self.collectionView.reloadData()
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
        let cellIndex: NSIndexPath? = (self.collectionView.indexPathForItem(at: p)! as NSIndexPath)
        guard let indexPath = cellIndex else {
            return
        }
        
        //do whatever you need to do
        guard let arrDays = self.arrDays else {
            return
        }
        
        let item = arrDays[indexPath.row]
        
        // 다음페이지 이동
        if let storyboard = AppDelegate.sharedNamedStroyBoard("Main") as? UIStoryboard {
            if let diaryPageVC: DiaryPageViewController = (storyboard.instantiateViewController(withIdentifier: "DiaryPageViewController") as? DiaryPageViewController) {
                diaryPageVC.selectedYear = item.year
                diaryPageVC.selectedMonth = item.month
                diaryPageVC.selectedWeek = indexPath.row % 7
                diaryPageVC.selectedDay = item.day
                
                self.navigationController?.pushViewController(diaryPageVC, animated: true)
            }
        }
        
        // 셀선택
        CalendarManager.selectedCell = item.cellIndex
        
        // 콜렉션뷰 전체 리로드
        parentVC?.collectionReloadDataAll()
    }
}

extension CalendarMonthViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 53.0, height: 60.0)
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
        
        let item = arrDays![indexPath.row]
        
        let message: String = "\(item.year)년 \(item.month)월 \(item.day)일 ToDo 리스트 보여주기"
        let popup = AlertMessagePopup.messagePopup(withMessage: message)
        popup.addActionConfirmClick("확인", handler: {
            
        })
        
        // 셀선택
        CalendarManager.selectedCell = item.cellIndex
        
        // 콜렉션뷰 전체 리로드
        parentVC?.collectionReloadDataAll()
    }
}
