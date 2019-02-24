//
//  SelectedPopup.swift
//  hello
//
//  Created by sama73 on 2019. 1. 24..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class SelectedPopup: BasePopup {

    @IBOutlet weak var tableView: UITableView!
    
    var tableViewHeight: CGFloat = 0.0
    // 보여줄 목록
    var arrListCell: [Any] = []
    // 셀 검색 키값
    var cellKey: String = ""
    // 콜백
    var cellSelected: ((_ item: Any?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 테이블 배열 설정
        tableViewPopupWithArrayData()
    }
    
    func addActionCellSelected(_ CellSelected: @escaping (_ item: Any?) -> Void) {
        cellSelected = CellSelected
    }
    
    // 테이블 배열 설정
    func tableViewPopupWithArrayData() {
        var count = arrListCell.count
        if count > 8 {
            count = 8
        }
        
        tableViewHeight = CGFloat(count * 44)
        
        // 375 기준으로 스케일이 적용되는데 스케일비 가로/세로값 구하기
        let scaleSize: CGSize = CommonUtil.viewScaleSize(with: view)
        tableView.frame = CGRect(x: 0.0, y: scaleSize.height, width: scaleSize.width, height: tableViewHeight)
		
        // 스케쥴 : 바로 애니메이션 주면 애니메이션이 안먹는 현상이 있다.
        perform(#selector(self.showAnimationSchedule), with: nil, afterDelay: 0.1)
    }
    
    // 최근검색 높이 제조정
    
    @objc override func showAnimationSchedule() {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
            // 375 기준으로 스케일이 적용되는데 스케일비 가로/세로값 구하기
            let scaleSize: CGSize = CommonUtil.viewScaleSize(with: self.view)
            self.tableView.frame = CGRect(x: 0.0, y: scaleSize.height - self.tableViewHeight, width: scaleSize.width, height: self.tableViewHeight)
        })
    }
    
    func hideAnimationSchedule(_ item: Any?) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            // 375 기준으로 스케일이 적용되는데 스케일비 가로/세로값 구하기
            let scaleSize: CGSize = CommonUtil.viewScaleSize(with: self.view)
            self.tableView.frame = CGRect(x: 0, y: scaleSize.height, width: scaleSize.width, height: self.tableViewHeight)
        }) { finished in
            if finished {
                if (self.cellSelected != nil) && item != nil {
                    self.cellSelected!(item)
                }

                self.removeFromParentVC()
//            [self dismissViewControllerAnimated:NO completion:nil];
            }
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
    
    // MARK: - Class Method
    /**
     message : 메세지
     */
    static func selectedPopup(arrayData: [Any], key: String?) -> SelectedPopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let selectedPopupVC = storyboard?.instantiateViewController(withIdentifier: "SelectedPopup") as? SelectedPopup
        selectedPopupVC!.arrListCell = arrayData
        selectedPopupVC!.cellKey = key ?? ""
        
        // 팝업으로 떳을때
        selectedPopupVC!.providesPresentationContextTransitionStyle = true
        selectedPopupVC!.definesPresentationContext = true
        selectedPopupVC!.modalPresentationStyle = .overFullScreen
        
        BasePopup.addChildVC(selectedPopupVC)
        
        return selectedPopupVC!
    }
    
}

extension SelectedPopup: UITableViewDataSource, UITableViewDelegate {
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        cell?.selectionStyle = .none
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.accessibilityTraits = UIAccessibilityTraits.button

        let item = arrListCell[indexPath.row]
        if (item is [AnyHashable : Any]) {
            var dicItem = item as? [AnyHashable : Any]
            if CommonUtil.isEmpty(cellKey as AnyObject) == false {
                cell!.textLabel?.text = dicItem?[cellKey] as? String
            } else {
                cell!.textLabel?.text = dicItem?.values.first as? String
            }
        } else {
            cell!.textLabel?.text = item as? String
        }
        
        return cell!
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        hideAnimationSchedule(arrListCell[indexPath.row])
    }
}
