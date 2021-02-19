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
            return [.red, .orange]
        case .debit:
            return [.green, .blue]
        case .saving:
            return [.purple, .blue]
        }
    }
}
