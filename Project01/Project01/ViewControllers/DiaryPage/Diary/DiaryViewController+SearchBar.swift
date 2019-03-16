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
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func loadSearchDiary() {
        self.isSearchMode = true
        self.searchedDiaryList.removeAll()
        self.searchedDiaryEditList.removeAll()
        self.searchedDiaryList = DBManager.shared.selectDiaryList(date: <#T##Date#>)
    }
}
