//
//  DiaryViewController+SearchBar.swift
//  Project01
//
//  Created by 박종현 on 15/03/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension DiaryViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchMode = false
        self.loadSearchDiary()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func loadSearchDiary() {
        self.isSearchMode = true
        self.searchedDiaryList.removeAll()
        self.searchedDiaryEditList.removeAll()
        
        let searchText = self.searchBar.text
        if searchText != "" {
            let date = Date.Get(year: self.selectedYear, month: self.selectedMonth, day: 1)
            self.searchedDiaryList = DBManager.shared.selectDiaryList(date: date, diary: searchText!)
            for _ in self.searchedDiaryList {
                self.searchedDiaryEditList.append(false)
            }
        }else {
            let date = Date.Get(year: self.selectedYear, month: self.selectedMonth, day: 1)
            self.searchedDiaryList = DBManager.shared.selectDiaryList(date: date)
            
            for _ in self.searchedDiaryList {
                self.searchedDiaryEditList.append(false)
            }
        }
        self.tableView.reloadData()
    }
}
