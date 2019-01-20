//
//  DiaryPageViewController.swift
//  PlannerDiary
//
//  Created by 김삼현 on 06/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

class DiaryPageViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!

	// 선택한 년/월/일
	public var selectedYear:Int = 0
	public var selectedMonth:Int = 0
	public var selectedWeek:Int = 0
	public var selectedDay:Int = 0

	var arrDiaryPage = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 375화면 기준으로 스케일 적용
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)

		// 동적 셀높이 조정
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 128
		
		// init Data
		arrDiaryPage += [["Hour":8, "Contents":"ddd"]]
		arrDiaryPage += [["Hour":9, "Contents":"ddd\ndfdfdf\ndfdfdf\ndfdfdf\ndfdfdf\ndfdfdf"]]
		arrDiaryPage += [["Hour":10, "Contents":""]]
		arrDiaryPage += [["Hour":11, "Contents":""]]
		arrDiaryPage += [["Hour":12, "Contents":""]]
		arrDiaryPage += [["Hour":13, "Contents":""]]
		arrDiaryPage += [["Hour":14, "Contents":""]]
		arrDiaryPage += [["Hour":15, "Contents":""]]
		arrDiaryPage += [["Hour":16, "Contents":""]]
		arrDiaryPage += [["Hour":17, "Contents":""]]
		arrDiaryPage += [["Hour":18, "Contents":""]]
		arrDiaryPage += [["Hour":19, "Contents":""]]
		arrDiaryPage += [["Hour":20, "Contents":""]]
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
	// 네비게이션 뒤로
	@IBAction func onNavigationBackClick(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}

extension DiaryPageViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1. Dequeue the custom header cell
		let vHeaderCell:DiarayPageHeaderCell = (tableView.dequeueReusableCell(withIdentifier: "DiarayPageHeaderCell") as? DiarayPageHeaderCell)!
        
        // 2. Set the various properties
        //        headerCell?.title.text = "Custom header from cell"
        //        headerCell?.title.sizeToFit()
        //
        //        headerCell?.subtitle.text = "The subtitle"
        //        headerCell?.subtitle.sizeToFit()
        //
        //        headerCell?.image.image = UIImage(named: "smiley-face")
		let monthTitle = CalendarManager.getMonthString(monthIndex: selectedMonth)
		let weekTitle = CalendarManager.getWeekFullString(weekIndex: selectedWeek)
		
		vHeaderCell.lbMonth.text = "\(monthTitle)"
		vHeaderCell.lbWeek.text = "\(weekTitle)"
		vHeaderCell.lbDay.text = "\(selectedDay)"
		vHeaderCell.ivBackground.image = CalendarManager.getMonthImage(monthIndex: selectedMonth)

        // 3. And return
        return vHeaderCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrDiaryPage.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DiaryPageCell = tableView.dequeueReusableCell(withIdentifier: "DiaryPageCell", for: indexPath) as! DiaryPageCell
        
        // Configure the cell...
        let dicDiaryPage = arrDiaryPage[indexPath.row]
        let hour:Int = dicDiaryPage["Hour"] as! Int
        cell.lbHour.text = "\(hour)"
        cell.lbContents.text = dicDiaryPage["Contents"] as? String
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
