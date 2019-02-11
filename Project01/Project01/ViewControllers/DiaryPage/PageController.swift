//
//  PageController.swift
//  Project01
//
//  Created by 박종현 on 11/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class PageController: UIPageViewController {
    
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
        for i in 0..<3 {
            let viewController = VCInstance(name: "DiaryPage")
            viewController.currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: i), to: currentDate)!
            arrVC.append(viewController)
        }
        
        if let firstVC = arrVC.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension PageController: UIPageViewControllerDelegate {
    
}

extension PageController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        guard let viewControllerIndex = arrVC.firstIndex(of: viewController as! DiaryPageViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            if self.checkMinimumDate() {
                currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: -1), to: currentDate)!
                arrVC.last!.currentDate = currentDate
                return arrVC.last
            } else {
                return nil
            }
        }
        
        guard previousIndex < arrVC.count  else {
            return nil
        }
        if self.checkMinimumDate() {
            currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: -1), to: currentDate)!
            arrVC[previousIndex].currentDate = currentDate
            return arrVC[previousIndex]
        } else {
            return nil
        }
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        guard let viewControllerIndex = arrVC.firstIndex(of: viewController as! DiaryPageViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < arrVC.count else {
            if self.checkMaximumDate() {
                currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: 1), to: currentDate)!
                arrVC.first!.currentDate = currentDate
                return arrVC.first
            } else {
                return nil
            }
        }
        
        guard nextIndex > 0  else {
            return nil
        }
        if self.checkMaximumDate() {
            currentDate = Calendar.current.date(byAdding: DateComponents(month: 0, day: 1), to: currentDate)!
            arrVC[nextIndex].currentDate = currentDate
            return arrVC[nextIndex]
        } else {
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
    func checkMinimumDate() -> Bool {
        let updatePage = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.minimumDate)
        if Double(temp) < 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    // 최대 날짜 검사
    func checkMaximumDate() -> Bool {
        
        let updatePage = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)
        let temp = updatePage!.timeIntervalSince(self.maximumDate)
        if Double(temp) > 0 {
            print("제한범위를 넘어갔습니다.")
            return false
        }else {
            
            return true
        }
    }
    
}
