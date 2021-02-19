//
//  Sub.swift
//  Subscriptions (iOS)
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation
import SwiftUI

final class Sub: Identifiable, ObservableObject {

    enum Recurrence: String, CaseIterable {
        case weekly, monthly, yearly
        
        var localized: LocalizedStringKey {
            switch self {
            case .weekly:
                return "weekly"
            case .monthly:
                return "monthly"
            case .yearly:
                return "yearly"
            }
        }
    }
    
    enum Transaction: String, CaseIterable {
        case credit, debit, saving
        
        var localized: LocalizedStringKey {
            switch self {
            case .credit:
                return "credit"
            case .debit:
                return "debit"
            case .saving:
                return "saving"
            }
        }
    }
    
    // MARK: - Properties
    
    let id: String
    @Published var name: String
    @Published var price: Double
    @Published var recurrence: Recurrence
    @Published var dueEvery: Date
    @Published var transactionType: Transaction
    
    // MARK: - Lifecycle
    
    init(name: String,
         price: Double,
         recurrence: Recurrence,
         dueEvery: Date,
         transactionType: Transaction) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
        self.recurrence = recurrence
        self.dueEvery = dueEvery
        self.transactionType = transactionType
    }
    
    init?(subRealm: SubRealm) {
        self.id = subRealm.id
        self.name = subRealm.name
        self.price = subRealm.price
        
        guard let recurrence = Recurrence(rawValue: subRealm.recurrence) else { return nil }
        self.recurrence = recurrence
        
        self.dueEvery = subRealm.dueEvery
        
        guard let transactionType = Transaction(rawValue: subRealm.transactionType) else { return nil }
        self.transactionType = transactionType
    }
    
}

#if DEBUG

extension Sub {
    static let one = list[0]
    
    static let list = [
        Sub(name: "Saving money",
            price: 100,
            recurrence: .monthly,
            dueEvery: Date().addingTimeInterval(60 * 60 * 24 * -1),
            transactionType: .saving),
        Sub(name: "Apple Music",
            price: 15.99,
            recurrence: .monthly,
            dueEvery: Date().addingTimeInterval(60 * 60 * 24 * 1),
            transactionType: .debit),
        Sub(name: "Refund",
            price: 4.99,
            recurrence: .monthly,
            dueEvery: Date().addingTimeInterval(60 * 60 * 24 * 40),
            transactionType: .credit)
    ]
}

#endif
