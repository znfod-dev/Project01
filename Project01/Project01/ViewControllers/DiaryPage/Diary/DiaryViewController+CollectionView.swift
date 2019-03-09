//
//  DiaryViewController+TableView.swift
//  Project01
//
//  Created by 박종현 on 03/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import UIKit

extension DiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        collectionView.deselectItem(at: indexPath, animated: true)
        print("row : \(row)")
        self.selectedMonth = row + 1
        self.collectionView.reloadData()
        
        self.tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = 12
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell:DiaryCollectionCell!
        
        if (row+1) == self.selectedMonth {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiarySelectedMonthCell", for: indexPath) as? DiaryCollectionCell
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryMonthCell", for: indexPath) as? DiaryCollectionCell
        }
        cell.monthLabel.text = "\(row+1) 월"
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSection = 1
        return numberOfSection
    }
    
}
