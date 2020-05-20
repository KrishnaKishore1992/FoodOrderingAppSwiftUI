//
//  OrdersListViewModel.swift
//  YummyItems
//
//  Created by Kittu Lalli on 13/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class OrdersListViewModel: ObservableObject {
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }()

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    @Published var ordersList: [Order] = []
    @Published var showAddOrder: Bool = false
    @Published var searchText: String = ""
    @Published var scopeTitle: String = ""
    @Published var showsScopeBar: Bool = false

    var anyCancellable: AnyCancellable?
    
    init() {
        fetchOrders()
        anyCancellable = $showAddOrder.sink(receiveValue: { (value) in
            if !value {
                self.fetchOrders()
            }
        })
    }
    
    func fetchOrders() {
        ordersList = CoreDataManager.fetchOrderDetails()
    }
    
    func getFormattedDate(for date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    func deleteOrders(at indexSet: IndexSet) {
        for element in indexSet {
            CoreDataManager.viewContext.delete(ordersList[element])
        }
        ordersList.remove(atOffsets: indexSet)
        try? CoreDataManager.viewContext.save()
    }
    
    func getFormatted(currency: String) -> String {
        guard let currencyValue = Int(currency) else {
            return currency
        }
        return  numberFormatter.string(for: currencyValue) ?? currency
    }
}
