//
//  Text+Gradient.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 19/02/2021.
//

import SwiftUI

extension Text {
    func gradientForeground(colors: [Color]) -> some View {
        overlay(LinearGradient(gradient: .init(colors: colors),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
            .mask(self)
    }
}
