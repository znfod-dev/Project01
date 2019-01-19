//
//  CalendarViewController.swift
//  Diary
//
//  Created by Byunsangjin on 03/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import FSCalendar
import BEMCheckBox

class CalendarViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var hideButton: UIButton!
    
    
    
    // MARK:- Variables
    var todoArray = Array<Todo>() // 전체 TodoList
    var selectedDay = Date() // 선택된 날짜
    
    // 완료된 todo 숨기기
    // true : 체크 todo 숨기기
    // false : 모든 todo 보여주기
    var isHide: Bool = UserDefaults.standard.bool(forKey: "isHide")
    
    var selectedDayTodo = Array<Todo>() // 특정 날짜의 TodoList
    
    
    
    // MARK:- Constants
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // statusBar 색상 적용
        self.statusBarSet(view: self.view)
        
        if self.isHide { // Hide 상태라면 hide버튼을 show로 변경
            self.hideButton.setTitle("show", for: .normal)
        }
        
        // 오늘 날짜로 선택날짜 TodoList에 넣기
        self.selectedDayTodoList()
    }
    
    
    
    // 날짜에 맞는 TodoList 불러오기
    func selectedDayTodoList(doReload: Bool = false) {
        if self.isHide { // 체크 박스를 보여주지 않을 때
            self.todoArray = DBManager.shared.selectTodoDB(withoutCheckedBox: true)
        } else { // 체크 박스 까지 보여줄 때
            self.todoArray = DBManager.shared.selectTodoDB()
        }
        
        self.selectedDayTodo.removeAll()
        for todo in self.todoArray {
            if todo.date?.string() == self.selectedDay.string() {
                self.selectedDayTodo.append(todo)
            }
        }
        
        if doReload { // doReload가 true라면
            self.reload()
        }
    }
    
    
    
    // 화면 갱신
    func reload() {
        self.tableView.reloadData()
        self.calendarView.reloadData()
    }
    
    
    
    // MARK:- Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Todo", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "save", style: .default, handler: { (_) in
            // 새로운 Todo 추가
            let uid = UUID().uuidString
            let title = alert.textFields?.last?.text
            let date = self.selectedDay
            
            let todo = Todo(uid: uid, title: title!, date: date)
            self.todoArray.append(todo)
            
            DBManager.shared.addTodoDB(todo: todo)
            
            self.selectedDayTodoList(doReload: true)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    
    @IBAction func hideBtnPressed(_ sender: Any) {
        if self.isHide { // hide 상태일 때, show를 누를 경우
            self.hideButton.setTitle("hide", for: .normal)
            self.ud.setValue(false, forKey: "isHide")
            ud.synchronize()
            self.isHide = false
        } else { // show 상태일 때, hide를 누르는 경우
            self.hideButton.setTitle("show", for: .normal)
            self.ud.setValue(true, forKey: "isHide")
            ud.synchronize()
            self.isHide = true
        }
        
        self.selectedDayTodoList(doReload: true)
    }
}



// MARK:- Extension
// UITableViewDelegate
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDayTodo.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        let todo = self.selectedDayTodo[indexPath.row]
        
        cell.todoLabel.text = todo.title
        
        cell.checkBox.boxType = .square
        cell.checkBox.delegate = self
        cell.checkBox.tag = indexPath.row
        if todo.isSelected! { // 체크박스에 체크가 되어있다면
            cell.checkBox.setOn(true, animated: true)
            cell.todoLabel.textColor = UIColor.lightGray
        } else { // 체크박스에 체크가 되어있지 않다면
            cell.checkBox.setOn(false, animated: true)
            cell.todoLabel.textColor = UIColor.black
        }
        
        return cell
    }
}


// FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택한 날짜
        self.selectedDay = date
        
        self.selectedDayTodoList(doReload: true)
    }
    
    
    
    // 서브 타이틀
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var count = 0
        for todo in self.todoArray {
            // 선택 날짜와 같은 todo의 갯수만 센다.
            if todo.date?.string() == date.string() && !todo.isSelected! {
                count = count + 1
            }
        }
        
        return count
    }
}



// BEMCheckBoxDelegate
extension CalendarViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        let todo = self.selectedDayTodo[checkBox.tag]
        if checkBox.on {
            todo.isSelected = true
        } else {
            todo.isSelected = false
        }
        
        DBManager.shared.updateTodoIsSelectedDB(todo: todo)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.selectedDayTodoList(doReload: true)
    }
}

