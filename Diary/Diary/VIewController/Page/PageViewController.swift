//
//  PageViewController.swift
//  Diary
//
//  Created by Byunsangjin on 03/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import RevealingSplashView

class PageViewController: UIPageViewController {
    
    
    lazy var subViewControllers:[UIViewController] = {
       return [
        UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController,
        UIStoryboard.init(name: "Planner", bundle: nil).instantiateViewController(withIdentifier: "_PlannerViewController") as! UINavigationController,
        UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        ]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSet()
        
        print(NSHomeDirectory())
    }
    
    
    
    func initSet() {
        self.delegate = self
        self.dataSource = self
        
        // 페이지 뷰 컨트롤러의 첫번째 페이지 설정
        self.setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        // 탭 제스쳐 비 활성화
        for recognizer in self.gestureRecognizers {            
            if recognizer is UITapGestureRecognizer {
                recognizer.isEnabled = false
            }
        }
        
        self.setSplashAnimation()
    }
    
    
    
    // 스플래쉬 뷰를 띄워주는 메소드
    func setSplashAnimation() {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "diaryIcon1.png")!, iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor.white)
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 2.0
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        
        revealingSplashView.startAnimation()
    }
    
    
}



extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.subViewControllers.count
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = self.subViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex-1]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = self.subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= self.subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex+1]
    }
}
