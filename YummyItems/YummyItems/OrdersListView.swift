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
    @State var editMode: EditMode = .inactive

    init() {
        UINavigationBar.appearance().tintColor = UIColor.red
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: self.$ordersListViewModel.searchText, scopeTitle: self.$ordersListViewModel.scopeTitle, showsScopeBar: self.$ordersListViewModel.showsScopeBar)
                List {
                    ForEach(self.ordersListViewModel.ordersList.filter { (item: Order) in
                        if self.ordersListViewModel.searchText.isEmpty {
                            return true
                        } else {
                            if self.ordersListViewModel.scopeTitle == "Price" {
                                return item.totalPrice!.contains(self.ordersListViewModel.searchText)
                            } else {
                                return item.customer!.localizedCaseInsensitiveContains(self.ordersListViewModel.searchText)
                            }
                        }
                    }, id: \.self) { (element: Order) in
                        NavigationLink(destination: self.getOrderDetailView(for: element)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(element.customer ?? "--").font(.body).padding(.bottom, 5.0)
                                    HStack(spacing: 5.0) {
                                        Text("Items Cost: ")
                                            .font(.footnote)
                                            .foregroundColor(Color.gray)
                                        Text(self.ordersListViewModel
                                            .getFormatted(currency: element.totalPrice ?? "--"))
                                            .font(.footnote)
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
                    }.onDelete { (indexSet) in
                        self.ordersListViewModel.deleteOrders(at: indexSet)
                    }
                }.navigationViewStyle(StackNavigationViewStyle())                .navigationBarTitle(Text("Orders").foregroundColor(Color.blue))
                    .navigationBarItems(leading:
                        Button(action: {
                            self.editMode.toggle()
                        }) {
                            Text(self.editMode.title)
                        }, trailing: Button(action: {
                            self.ordersListViewModel.showAddOrder.toggle()
                        }){
                            Image(systemName: "plus")
                                .foregroundColor(Color.red)
                                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
                    }).sheet(isPresented: self.$ordersListViewModel.showAddOrder) {
                        YummyMenuList(isPresented: self.$ordersListViewModel.showAddOrder)
                }
            }
            .environment(\.editMode, self.$editMode)
        }
    }
    
    private func getOrderDetailView(for element: Order) -> OrderDetailView {
        OrderDetailView(orderDetailViewModel: OrderDetailViewModel(orderDetails: element))
    }
}

extension EditMode {
    
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
