//
//  OrdersListViewModel.swift
//  YummyItems
//
//  Created by Kittu Lalli on 13/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import Combine

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
    
    func getFormatted(currency: String) -> String {
        guard let currencyValue = Int(currency) else {
            return currency
        }
        return  numberFormatter.string(for: currencyValue) ?? currency
    }
}
