//
//  YummyMenuListViewModel.swift
//  YummyItems
//
//  Created by Kittu Lalli on 12/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import SwiftUI

class YummyMenuListViewModel: ObservableObject {
    
    @Published var selectedItems: [Item] = []
    @Published var items: [Menu] = Menu.allItems()
    @Published var placedOrder: Bool = false
    @Published var customerName: String = ""
    @Published var isImagePickerShown: Bool = false
    @Published var customerImage: UIImage?

    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }()

    func totalPrice(enableFormatter: Bool = true) -> String {
        var totalPrice: Int = 0
        totalPrice = selectedItems.reduce(totalPrice, { (accumulatedValue, nextItem) -> Int in
            let finalValue = (accumulatedValue + Int(nextItem.cost)!)
            return finalValue
        })
        return enableFormatter ? getFormatted(currency: "\(totalPrice)") : "\(totalPrice)"
    }

    func getFormatted(currency: String) -> String {
        guard let currencyValue = Int(currency) else {
            return currency
        }
        return  numberFormatter.string(for: currencyValue) ?? currency
    }

    func placeOrderFor(name: String) {
        CoreDataManager.saveOrderDetails(for: name.isEmpty ? "Customer" : name, details: selectedItems, totalPrice: "\(totalPrice(enableFormatter: false))", customerImage: customerImage)
        placedOrder = true
    }
}
