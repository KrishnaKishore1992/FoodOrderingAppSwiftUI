//
//  Extensions.swift
//  OrderMaking
//
//  Created by Kittu Lalli on 29/04/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum CodableError: Error {
    case notFound(String)
}

extension String {
    
    func parse<T: Codable>() throws -> T {
        if let fileUrl = Bundle.main.url(forResource: self, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            let parsedElements = try PropertyListDecoder().decode(T.self, from: data)
            return parsedElements
        }
        throw CodableError.notFound("File Not Found")
    }
}

extension UIColor {
    
    static var gray_R238_G238_B238: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333856702, blue: 0.9333333333, alpha: 1)
    static var black_R8_G8_B8: UIColor = #colorLiteral(red: 0.03136632219, green: 0.03137653694, blue: 0.03136408702, alpha: 1)
    static var gray_R225_G225_B225: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8824027181, blue: 0.8823529412, alpha: 1)
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}
