//
//  Transaction+GradientColors.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 19/02/2021.
//

import SwiftUI

extension Sub.Transaction {
    var gradientColors: [Color] {
        switch self {
        case .credit:
            return [.green, .blue]
        case .debit:
            return [.red, .orange]
        case .saving:
            return [.purple, .blue]
        }
    }
}
