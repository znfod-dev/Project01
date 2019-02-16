//
//  PageController.swift
//  Project01
//
//  Created by 박종현 on 11/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class PageController: UIPageViewController {
	
	// 이전 보여주는 페이지
	var focusIndex: Int = -1
    var currentDate = Date()
    
    var minimumDate = DBManager.sharedInstance.loadMinimumDateFromUD()
    var maximumDate = DBManager.sharedInstance.loadMaximumDateFromUD()
    
    lazy var arrVC: [DiaryPageViewController] = Array<DiaryPageViewController>()
    
    private func VCInstance(name: String) -> DiaryPageViewController {
        let viewController = UIStoryboard(name: "DiaryPage", bundle: nil).instantiateViewController(withIdentifier: name) as! DiaryPageViewController
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
		
		focusIndex = 1
		var countDay = -1

		// 선택한 날짜가 시작 날짜 선택 가능하면...
		if self.checkMinimumDate(checkDate: currentDate) == false {
			focusIndex = 0
			countDay = 0
		}
		
		// 선택한 날짜가 마지막 날짜 선택 가능하면...
		if self.checkMaximumDate(checkDate: currentDate) == false {
			focusIndex = 2
			countDay = -2
		}
		
		for _ in 0..<3 {
            let viewController = VCInstance(name: "DiaryPage")
            viewController.currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: countDay), to: currentDate)!
			viewController.parentVC = self
            arrVC.append(viewController)
			
			countDay += 1
        }
		
		let curentVC = arrVC[focusIndex]
		setViewControllers([curentVC], direction: .forward, animated: true, completion: nil)
		
        // Do any additional setup after loading the view.
    }
	
	// 타임 아웃 되었을때...
	@objc func UserInteractionClear() {
		self.view.isUserInteractionEnabled = true
	}
}

extension PageController: UIPageViewControllerDataSource {
	
	// 이전페이지 이동
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let curentIndex = arrVC.firstIndex(of: viewController as! DiaryPageViewController) else {
			return nil
		}
		
		print("curentIndex=\(curentIndex)")
		
		let curentVC: DiaryPageViewController = self.arrVC[curentIndex]
		if self.checkMinimumDate(checkDate: curentVC.currentDate) {
			var prevIndex = curentIndex - 1
			if prevIndex < 0 {
				prevIndex = arrVC.count - 1
			}
			
			// 페이징 애니 완료 될때까지 화면 제어 막음
			self.view.isUserInteractionEnabled = false
			// 스케쥴 시작
			self.perform(#selector(self.UserInteractionClear), with: nil, afterDelay: 2.0)

			return arrVC[prevIndex]
		}
		else {
			return nil
		}
    }
	
	// 다음페이지 이동
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let curentIndex = arrVC.firstIndex(of: viewController as! DiaryPageViewController) else {
			return nil
		}
		
		print("curentIndex=\(curentIndex)")
		
		let curentVC: DiaryPageViewController = self.arrVC[curentIndex]
		if self.checkMaximumDate(checkDate: curentVC.currentDate) {
			var nextIndex = curentIndex + 1
			if nextIndex >= arrVC.count {
				nextIndex = 0
			}
			
			// 페이징 애니 완료 될때까지 화면 제어 막음
			self.view.isUserInteractionEnabled = false
			// 스케쥴 시작
			self.perform(#selector(self.UserInteractionClear), with: nil, afterDelay: 2.0)

			return arrVC[nextIndex]
		}
		else {
			return nil
		}
    }
	
    // The number of items reflected in the page indicator.
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrVC.count
    }
    
    // The selected item reflected in the page indicator.
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first,
            let firstVCIndex = arrVC.firstIndex(of: firstVC as! DiaryPageViewController) else {
                return 0
        }
        
        return firstVCIndex
    }
	
    // 최소 날짜 검사
	func checkMinimumDate(checkDate: Date) -> Bool {
        let updatePage = Calendar.current.date(byAdding: .day, value: -1, to: checkDate)
        let temp = updatePage!.timeIntervalSince(self.minimumDate)
        if Double(temp) < 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    // 최대 날짜 검사
    func checkMaximumDate(checkDate: Date) -> Bool {
        
        let updatePage = Calendar.current.date(byAdding: .day, value: 1, to: checkDate)
        let temp = updatePage!.timeIntervalSince(self.maximumDate)
        if Double(temp) > 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
}

extension PageController: UIPageViewControllerDelegate {
	public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		// 페이징 애니 완료 될때까지 화면 제어 해제
		self.view.isUserInteractionEnabled = true
		// 스케쥴 종료
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.UserInteractionClear), object: nil)

		if completed == false {
			return
		}
		
		guard let current = self.viewControllers?.first else {
			// TODO handle error
			return
		}
		
		guard let curentIndex = self.arrVC.firstIndex(of: current as! DiaryPageViewController) else {
			// TODO handle error
			return
		}
		
		let curentVC: DiaryPageViewController = self.arrVC[curentIndex]
		
		var isPrev = false
		if curentIndex == 0 {
			if focusIndex == 1 {
				isPrev = true
			}
		}
		else if curentIndex == 1 {
			if focusIndex == 2 {
				isPrev = true
			}
		}
		else {
			if focusIndex == 0 {
				isPrev = true
			}
		}
		
		currentDate = curentVC.currentDate
		focusIndex = curentIndex
		
		// 이전페이지 이동
		if isPrev {
			if self.checkMinimumDate(checkDate: currentDate) {
				var prevIndex = curentIndex - 1
				if prevIndex < 0 {
					prevIndex = arrVC.count - 1
				}
				
				currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: -1), to: currentDate)!
				let prevVC: DiaryPageViewController = self.arrVC[prevIndex]
				prevVC.currentDate = currentDate
			}
		}
		// 다음페이지 이동
		else {
			if self.checkMaximumDate(checkDate: currentDate) {
				var nextIndex = curentIndex + 1
				if nextIndex >= arrVC.count {
					nextIndex = 0
				}
				
				currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: 1), to: currentDate)!
				let nextVC: DiaryPageViewController = self.arrVC[nextIndex]
				nextVC.currentDate = currentDate
			}
		}
	}
}
