//
//  ContentView.swift
//  YummyItems
//
//  Created by Kittu Lalli on 12/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import SwiftUI

struct YummyMenuList: View {
    
    @ObservedObject var viewModel: YummyMenuListViewModel = YummyMenuListViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack(spacing: 10){
                    VStack {
                        Text("Customer Name")
                            .foregroundColor(Color.red)
                            .font(.caption)
                            .frame(alignment: Alignment(horizontal: .center, vertical: .bottom))
                        TextField("Enter Customer Name", text: self.$viewModel.customerName)
                            .frame(width: 100, height: 30, alignment: .trailing)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.center)
                            .border(Color.gray, width: 1.0/UIScreen.main.scale)
                    }.frame(alignment: .center)
                    VStack(spacing: 05) {
                        HStack(spacing: 3) {
                            Text("Item(s): ")
                            Text("\(self.viewModel.selectedItems.count)")
                                .foregroundColor(Color.red)
                        }.frame(width: 200, alignment: .leading)
                        HStack(spacing: 3) {
                            Text("Total Cost: ")
                            Text(self.viewModel.totalPrice())
                                .foregroundColor(Color.red)
                        }.frame(width: 200, alignment: .leading)
                    }.padding(.top, 15)
                }
                List() {
                    ForEach(self.viewModel.items, id: \.category) { menu in
                        Section(header:  HStack(){
                            Text(menu.category.rawValue)
                                .frame(height: 40)
                                .foregroundColor(Color.red)
                                .foregroundColor(Color(UIColor.gray_R238_G238_B238))
                        }.onTapGesture {
                            if let firstIndex = (self.viewModel.items.firstIndex { $0.category == menu.category }) {
                                self.viewModel.items[firstIndex].isExpanded.toggle()
                            }
                        }) {
                            if menu.isExpanded {
                                ForEach(menu.items, id: \.id) { item in
                                    ItemCell(item: item, selectedItems: self.$viewModel.selectedItems).background(Color.clear)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Yummy Menu...!")
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }) {
                Text("Cancel")
                    .foregroundColor(Color.red)
                }, trailing: Button(action: {
                    self.viewModel.placedOrder.toggle()
                    self.viewModel.placeOrderFor(name: self.viewModel.customerName)
                }) {
                    Text("Place Order")
                        .foregroundColor(Color.red)
            })
        }.background(Color.green)
            .alert(isPresented: self.$viewModel.placedOrder, content: {
                Alert(title: Text("Hurrah...!"), message: Text("Your order placed.\nWait till lock down complete to receive the order"), dismissButton: Alert.Button.default(Text("Ok"), action: {
                    self.isPresented.toggle()
                }))
            })
    }
}

struct ItemCell: View {
    
    @State var item: Item
    @Binding var selectedItems: [Item]
    
    var body: some View {
        return HStack() {
            VegIndicator(isVeg: true)
                .frame(width: 15, height: 15)
                .background(Color.clear)
            VStack(alignment: .leading) {
                Text(item.name).font(.body)
                Text((Locale.current.currencySymbol ?? "") + item.cost)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }.background(Color.clear)
            Spacer().background(Color.clear)
            StepperView(count: self.$item.count) { isIncremented in
                if isIncremented {
                    self.selectedItems.append(self.item)
                } else {
                    if let index = ( self.selectedItems.firstIndex { $0.id == self.item.id }) {
                        self.selectedItems.remove(at: index)
                    }
                }
            }.padding().buttonStyle(DefaultButtonStyle())
                .frame(height: 44)
                .background(Color.clear)
        }
    }
}

struct VegIndicator: View {
    
    let isVeg: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().fill(Color.clear)
                .border((isVeg ? Color.green : Color.red), width: 1.0)
            Circle().fill((isVeg ? Color.green : Color.red)).padding([.leading, .trailing, .top, .bottom], 3.0)
        }
    }
}

struct StepperView:View {
    
    @Binding var count: Int
    let onTap: ((Bool) -> Void)

    var body: some View {
        HStack(spacing: 0) {
            StepperButton(content: Text("-").font(.title).foregroundColor(Color(UIColor.black_R8_G8_B8))) {
                self.count = Swift.max(self.count - 1, 0)
                self.onTap(false)
            }.cornerRadius(15.0, corners: [.topLeft, .bottomLeft])
                .buttonStyle(PlainButtonStyle())
            Text("\(self.count)")
                .font(.subheadline)
                .foregroundColor(Color.red)
                .frame(width: 20)
                .frame(maxHeight: .infinity)
                .background(Color(UIColor.gray_R238_G238_B238))
            StepperButton(content: Text("+").font(.title).foregroundColor(Color(UIColor.black_R8_G8_B8))) {
                self.count += 1
                self.onTap(true)
            }.cornerRadius(15.0, corners: [.topRight, .bottomRight])
                .buttonStyle(PlainButtonStyle())
        }.frame(maxHeight: 35)
    }
}

struct StepperButton: View {
    
    let content: Text
    let handler: (() -> Void)
    
    var body: some View {
        Button(action: {
            self.handler()
        }, label: {
            content
        }) .frame(width: 30, alignment: .center)
            .frame(maxHeight: 35)
            .background(Color(UIColor.gray_R238_G238_B238))
    }
}
 /*   I am trying to implement small animation while List view is dragging based on the content offset it moved in SwiftUI. Could you please help me out how to identify content offset of the Listview similarly like in UITableView.How Can I shift my List View content Insets of 50px from bottom just like set content insets in UITableview so that scrollable view will shift up by provided padding.

    How to identify when a List is scrolled & to get visible cell items(Visible Indexpaths in case of UITableViews)

Equivalent Scrollview delegate methods in List View
*/

/*struct FooterView: View {
    
    @State var showSuccess: Bool = false
    let selectedItems: [Item]
    let totalPrice: Int
    let placeOrder: (String) -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(0.3)
            VStack(spacing: 15) {
                HStack {
                    VStack(spacing: 10) {
                        Text("Item(s): ")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("Total Cost: ")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.frame(maxWidth: 100, alignment: .trailing)
                    VStack(spacing: 10) {
                        Text("\(self.selectedItems.count)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color.red)
                        Text(Locale.current.currencySymbol! + "\(self.totalPrice)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color.red)
                    }.frame(maxWidth: 80, alignment: .trailing)
                        .padding(.trailing, 50)
                }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .init(horizontal: .trailing, vertical: .top))
                    .background(Color.clear)
                    .padding(.top, 15)
                Button(action: {
                    self.placeOrder("Customer")
                }) {
                    Text("Place Order")
                }.foregroundColor(Color.white)
                    .frame(maxWidth: 150, maxHeight: 40)
                    .background(Color.green)
                    .cornerRadius(5.0)
            }.frame(maxHeight: .infinity, alignment: .top)
        }.background(Color.clear)
    }
}
*/
