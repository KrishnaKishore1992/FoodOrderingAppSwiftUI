//
//  CoreDataManager.swift
//  YummyItems
//
//  Created by Kittu Lalli on 13/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static var viewContext: NSManagedObjectContext = {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }()
    
    static func saveOrderDetails(for customer: String, details: [Item], totalPrice: String, customerImage: UIImage?) {
        
        let sameCategoryItems = Dictionary(grouping: details) { $0.id }
        let order = Order(context: viewContext)
        order.totalPrice = totalPrice
        order.customer = customer
        order.date = Date()
        order.customerImage = customerImage
        let orderDetails = NSMutableSet()
        for menu in sameCategoryItems {
            let orderItem = OrderItem(context: viewContext)
            orderItem.categoryId = menu.value.first?.category.rawValue
            orderItem.id = menu.key
            orderItem.count = "\(menu.value.count)"
            orderItem.price = menu.value.first?.cost
            orderItem.name = menu.value.first?.name
            orderDetails.add(orderItem)
        }
        order.orderDetails = orderDetails
        try? viewContext.save()
    }
    
    static func fetchOrderDetails() -> [Order]{
        
        let fetchRequest: NSFetchRequest = Order.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let result = try? viewContext.fetch(fetchRequest)
        return result ?? []
    }
}
