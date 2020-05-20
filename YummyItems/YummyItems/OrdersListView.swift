//
//  OrdersListView.swift
//  YummyItems
//
//  Created by Kittu Lalli on 13/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import SwiftUI
import CoreData

struct OrdersListView: View {
    
    @ObservedObject private var ordersListViewModel = OrdersListViewModel()
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor.red
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.ordersListViewModel.ordersList, id: \.self) { (element: Order) in
                    NavigationLink(destination: self.getOrderDetailView(for: element)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(element.customer ?? "--").font(.body).padding(.bottom, 5.0)
                                HStack(spacing: 5.0) {
                                    Text("Items Cost: ")
                                        .font(.footnote)
                                        .foregroundColor(Color.gray)
                                    Text(self.ordersListViewModel.getFormatted(currency: element.totalPrice ?? "--"))                                        .font(.footnote)
                                        .foregroundColor(Color.red)
                                    Text("Total Items: " )
                                        .font(.footnote)
                                        .foregroundColor(Color.gray)
                                    Text(("\(element.orderDetails?.count ?? 0)"))
                                        .font(.footnote)
                                        .foregroundColor(Color.red)
                                }
                            }.padding(.leading, 5.0)
                            Spacer()
                            Text(self.ordersListViewModel.getFormattedDate(for: element.date) ?? "--")                                    .foregroundColor(Color.gray)
                                .font(.caption)
                        }
                    }.buttonStyle(PlainButtonStyle())
                }
            }.navigationViewStyle(StackNavigationViewStyle())                .navigationBarTitle(Text("Orders").foregroundColor(Color.blue))
                .navigationBarItems(trailing: Button(action: {
                        self.ordersListViewModel.showAddOrder.toggle()
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(Color.red)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
                }).sheet(isPresented: self.$ordersListViewModel.showAddOrder) {
                    YummyMenuList(isPresented: self.$ordersListViewModel.showAddOrder)
            }
        }
    }
    
    private func getOrderDetailView(for element: Order) -> OrderDetailView {
        OrderDetailView(orderDetailViewModel: OrderDetailViewModel(orderDetails: element))
    }
}
