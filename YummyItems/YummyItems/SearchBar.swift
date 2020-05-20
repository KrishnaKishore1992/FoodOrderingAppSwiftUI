//
//  SearchBarView.swift
//  YummyItems
//
//  Created by Kittu Lalli on 20/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SearchBar: UIViewRepresentable {
    
    @Binding var searchText: String
    @Binding var scopeTitle: String
    @Binding var showsScopeBar: Bool

    private static let scopeTitles = ["Customer Name", "Price"]
    
    class SearchBarDelegate: NSObject, UISearchBarDelegate {
        
        @Binding var searchText: String
        @Binding var scopeTitle: String
        @Binding var showsScopeBar: Bool

        init(searchText: Binding<String>, scopeTitle: Binding<String>, showsScopeBar: Binding<Bool>) {
            _searchText = searchText
            _scopeTitle = scopeTitle
            _showsScopeBar = showsScopeBar
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            searchBar.showsScopeBar = true
            searchBar.placeholder = "Search using " + SearchBar.scopeTitles[0]
            showsScopeBar = true
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
        }
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            searchBar.placeholder = "Search using " + SearchBar.scopeTitles[selectedScope]
            scopeTitle = SearchBar.scopeTitles[selectedScope]
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            searchBar.showsScopeBar = false
            showsScopeBar = false
            searchText = ""
        }
    }
    
    func makeCoordinator() -> SearchBarDelegate {
        SearchBarDelegate(searchText: $searchText, scopeTitle: $scopeTitle, showsScopeBar: $showsScopeBar)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.scopeButtonTitles = SearchBar.scopeTitles
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = searchText
    }
}
