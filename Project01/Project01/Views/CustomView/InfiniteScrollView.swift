//
//  InfiniteScrollView.swift
//  Test2
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 김삼현. All rights reserved.
//

import UIKit

// 해상도 사이즈
//let DEF_SCREEN_375_WIDTH = UIScreen.main.bounds.width

class InfiniteScrollView: UIScrollView {
    
    // 센터 페이지 인덱스
    public var centerIndex:Int = 0
    var arrScrollSubCell = [UIView]()
    
    // 스크롤뷰에 서브뷰 추가
    public func addScrollSubview(_ subCell: UIView) {
        self.addSubview(subCell)
        arrScrollSubCell.append(subCell)
        
        // 페이지의 중간 인덱스를 구해준다.
        centerIndex = Int(arrScrollSubCell.count / 2)
    }
    
    // 서브뷰 RemoveAll
    public func removeAllSubCell() {
        arrScrollSubCell.removeAll()
        
        for subCell in self.subviews {
            subCell.removeFromSuperview()
        }
    }
    
    // 서브셀 위치 재설정
    public func reposSubCell() {
        
        // 도출 개시의 x, y 위치
        var px:CGFloat = 0.0
        
        for subCell in arrScrollSubCell {
            // 스크롤뷰 Subview RemoveAll 되어 있는 상태여야 한다.
            self.addSubview(subCell)
            
            // 서브셀 위치 재설정
            var viewFrame = subCell.frame
            viewFrame.origin = CGPoint(x: px, y: subCell.frame.origin.y)
            subCell.frame = viewFrame
            px += DEF_SCREEN_375_WIDTH
        }
    }
    
    // 페이지 이동 가능한지 체크
    public func isScrollable() -> Bool {
        // 페이지뷰가 3장 이상이어야 한다.
        if centerIndex == 0 {
            return false
        }
        
        return true
    }
    
    // 이전페이지 인덱스
    public func prevPageIndex() -> CGFloat {
        // 페이지 이동 가능한지 체크
        if isScrollable() == false {
            return 0.0
        }
        
        return CGFloat(centerIndex-1)
    }
    
    // 다음페이지 인덱스
    public func nextPageIndex() -> CGFloat {
        // 페이지 이동 가능한지 체크
        if isScrollable() == false {
            return 0.0
        }
        
        // sama73: 페이지 갯수
        let pageCount: Int = Int(self.contentSize.width / self.bounds.width)
        if pageCount != 3 {
            return CGFloat(1)
        }
        
        return CGFloat(centerIndex+1)
    }
    
    // 포커스 페이지 이동 시킨다.
    public func goFocusPageMove(focusIndex: Int) {
        // 포커스 영역이 아닌경우...
        if focusIndex < 0 && focusIndex >= arrScrollSubCell.count {
            return
        }
        
        // UIScrollView의 컨텐트 크기를 이미지의 총 크기에 맞추기
        let nWidth:CGFloat = DEF_SCREEN_375_WIDTH * CGFloat(arrScrollSubCell.count)
        self.contentSize = CGSize(width: nWidth, height: self.bounds.height)
        
        // 중간셀 위치 스크롤 시켜준다.
        self.contentOffset.x = DEF_SCREEN_375_WIDTH * CGFloat(focusIndex)
    }
    
    // 센터 페이지 이동 시킨다.
    public func goCenterPageMove() {
        // UIScrollView의 컨텐트 크기를 이미지의 총 크기에 맞추기
        let nWidth:CGFloat = DEF_SCREEN_375_WIDTH * CGFloat(arrScrollSubCell.count)
        self.contentSize = CGSize(width: nWidth, height: self.bounds.height)
        
        // 중간셀 위치 스크롤 시켜준다.
        self.contentOffset.x = DEF_SCREEN_375_WIDTH * CGFloat(centerIndex)
    }
    
    // 이전 페이지 이동시 처리
    public func goPrevPage() {
        
        // 페이지 이동 가능한지 체크
        if isScrollable() == false {
            return
        }
        
        // 스크롤뷰 Subview RemoveAll
        for subCell in self.subviews {
            subCell.removeFromSuperview()
        }
        
        // 마지막뷰를 첫번째로 이동
        let subCellLast = arrScrollSubCell.popLast()
        arrScrollSubCell.insert(subCellLast!, at: 0)
        
        // 서브셀 위치 재설정
        self.reposSubCell()
        
        // 센터 페이지 이동 시킨다.
        self.goCenterPageMove()
    }
    
    // 다음 페이지 이동시 처리
    public func goNextPage() {
        
        // 페이지 이동 가능한지 체크
        if isScrollable() == false {
            return
        }
        
        // 스크롤뷰 Subview RemoveAll
        for subCell in self.subviews {
            subCell.removeFromSuperview()
        }
        
        // 맨처음뷰를 첫번째로 이동
        let subCellFirst = arrScrollSubCell.removeFirst()
        arrScrollSubCell.append(subCellFirst)
        
        // 서브셀 위치 재설정
        self.reposSubCell()
        
        // 센터 페이지 이동 시킨다.
        self.goCenterPageMove()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
