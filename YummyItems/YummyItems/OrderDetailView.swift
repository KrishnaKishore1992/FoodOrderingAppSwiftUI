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
            CustomerImageView(customerImage: self.orderDetailViewModel.customerImage)
            OrderDetailRow(titleLabel: "Customer", descLabel: self.orderDetailViewModel.customerName, countLabel: "")
            OrderDetailRow(titleLabel: "Order Date: ", descLabel: self.orderDetailViewModel.getFormattedDate(for: self.orderDetailViewModel.orderDetails.date) ?? "--", countLabel: "")
            Rectangle()
                .fill(Color.red)
                .frame(maxWidth: .infinity, maxHeight: 1.0/UIScreen.main.scale)
            OrderDetailRow(titleLabel: "Total: ", descLabel: self.orderDetailViewModel.getFormatted(currency: self.orderDetailViewModel.totalCost), countLabel: "", titleFont: 25, descFont: 30.0)
            Rectangle()
                .fill(Color.red)
                .frame(maxWidth: .infinity, maxHeight: 1.0/UIScreen.main.scale)
            VStack {
                ForEach(Array(self.orderDetailViewModel.orderItems.keys), id: \.self) { (key: ItemCategory) in
                    Section(header: Text(key.rawValue)
                        .foregroundColor(Color.red), content: {
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

struct CustomerImageView: View {
    
    let customerImage: UIImage?
    
    var body: some View {
        if let customerImage = self.customerImage {
            return AnyView(Image(uiImage: customerImage).resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(50.0)
            )
        } else {
            return AnyView(EmptyView())
        }
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
