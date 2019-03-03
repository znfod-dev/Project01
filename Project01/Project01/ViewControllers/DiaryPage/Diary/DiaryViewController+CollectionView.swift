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
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = 0
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let cell:DiaryCollectionCell!
        if row == selectedMonth {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiarySelecedMonthCell")
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiaryMonthCell")
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSection = 0
        return numberOfSection
    }
    
}
