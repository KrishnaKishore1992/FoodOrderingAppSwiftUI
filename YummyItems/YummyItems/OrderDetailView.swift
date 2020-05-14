//
//  OrderDetailView.swift
//  YummyItems
//
//  Created by Kittu Lalli on 14/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import SwiftUI

struct OrderDetailView: View {
    
    @ObservedObject var orderDetailViewModel: OrderDetailViewModel
    
    var body: some View {
        ScrollView {
            OrderDetailRow(titleLabel: "Customer", descLabel: self.orderDetailViewModel.customerName, countLabel: "")
            OrderDetailRow(titleLabel: "Order Date: ", descLabel: self.orderDetailViewModel.getFormattedDate(for: self.orderDetailViewModel.orderDetails.date) ?? "--", countLabel: "")
            Rectangle()
                .fill(Color.purple)
                .frame(maxWidth: .infinity, maxHeight: 1.0/UIScreen.main.scale)
            OrderDetailRow(titleLabel: "Total: ", descLabel: self.orderDetailViewModel.getFormatted(currency: self.orderDetailViewModel.totalCost), countLabel: "", titleFont: 25, descFont: 30.0)
            Rectangle()
                .fill(Color.purple)
                .frame(maxWidth: .infinity, maxHeight: 1.0/UIScreen.main.scale)
            VStack {
                ForEach(Array(self.orderDetailViewModel.orderItems.keys), id: \.self) { (key: ItemCategory) in
                    Section(header: Text(key.rawValue)
                        .foregroundColor(Color.purple), content: {
                            ForEach(self.orderDetailViewModel.orderItems[key]!, id: \.self) { (orderItem: OrderItem) in
                                OrderDetailRow(titleLabel: self.orderDetailViewModel.getOrderTitle(for: orderItem), descLabel: self.orderDetailViewModel.getOrderDesc(for: orderItem), countLabel: self.orderDetailViewModel.getOrderItemCount(for: orderItem))
                            }
                    })
                }.padding(10)
            }
        }.padding()
            .navigationBarTitle("Order Details")
    }
}

private struct OrderDetailRow: View {
    
    let titleLabel: String
    let descLabel: String
    let countLabel: String
    var titleFont: CGFloat = 18
    var descFont: CGFloat = 17
    
    var body: some View {
        HStack {
            Text(titleLabel)
                .font(.system(size: descFont))
                .padding(.bottom, 5.0)
            if !countLabel.isEmpty {
                Text("(x\(countLabel))").font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Text(descLabel)
                .foregroundColor(Color.red)
                .font(.system(size: descFont))
                .padding(.bottom, 5.0)
        }.frame(alignment: .center)
    }
}
