//
//  OrderDetailViewModel.swift
//  YummyItems
//
//  Created by Kittu Lalli on 14/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import UIKit

class OrderDetailViewModel: ObservableObject {
    
    @Published var orderDetails: Order
    @Published var showImagePreview: Bool = false
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }()
    
    init(orderDetails: Order) {
        self.orderDetails = orderDetails
    }
    
    var customerName: String {
        orderDetails.customer ?? "--"
    }
    
    var customerImage: UIImage? {
        orderDetails.customerImage
    }
    
    var totalCost: String {
        orderDetails.totalPrice ?? "--"
    }
    
    func getFormattedDate(for date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    var orderItems: [ItemCategory: [OrderItem]] {
        
        let items = Dictionary(grouping: orderDetails.orderDetails?.allObjects as? [OrderItem] ?? []) { (element) -> ItemCategory in
            return ItemCategory(rawValue: element.categoryId!)!
        }
        return items
    }
    
    func getOrderTitle(for item: OrderItem) -> String {
        item.name ?? "--"
    }

    func getOrderItemCount(for item: OrderItem) -> String {
        item.count ?? "--"
    }
    
    func getOrderDesc(for item: OrderItem) -> String {
        
        guard  let count = item.count, let price = item.price, let totalItems = Int(count), let individualPrice = Int(price)  else {
            return "--"
        }
        
        let itemTotal = "\(totalItems * individualPrice)"
        return getFormatted(currency: "\(itemTotal)")
    }
    
    func getFormatted(currency: String) -> String {
        guard let currencyValue = Int(currency) else {
            return currency
        }
        return  numberFormatter.string(for: currencyValue) ?? currency
    }
}
