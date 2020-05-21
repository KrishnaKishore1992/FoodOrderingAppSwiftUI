//
//  ImagePreviewView.swift
//  YummyItems
//
//  Created by Kittu Lalli on 21/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import SwiftUI

struct ImagePreviewView: View {
    
    var image: UIImage
    @Binding var showImagePreview: Bool
    @State private var scaleFactor: CGFloat = 1.0
    let customerName: String
    
    var body: some View {
        NavigationView {
            Image(uiImage: image)
                .resizable()
                .scaleEffect(scaleFactor)
                .frame(width: 300, height: 300)
                .gesture(MagnificationGesture().onChanged{ (value) in
                    self.scaleFactor = value.magnitude
                }).gesture(TapGesture(count: 2).onEnded({ (_) in
                    self.scaleFactor = 1.0
                })).animation(.spring())
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle(Text(customerName + "'s Pic"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showImagePreview.toggle()
                }) {
                    Text("Cancel")
                })
        }
    }
}
