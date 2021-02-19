//
//  Sub.swift
//  Subscriptions (iOS)
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation
import SwiftUI

struct Sub: Identifiable {

    enum Recurrence: String, CaseIterable {
        case weekly, monthly, yearly
        
        var localized: String {
            switch self {
            case .weekly:
                return "Weekly"
            case .monthly:
                return "Monthly"
            case .yearly:
                return "Yearly"
            }
        }
    }
    
    enum Transaction: String, CaseIterable {
        case credit, debit, saving
        
        var localized: String {
            switch self {
            case .credit:
                return "Credit"
            case .debit:
                return "Debit"
            case .saving:
                return "Saving"
            }
        }
    }
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let price: Double
    let recurrence: Recurrence
    let dueEvery: Date
    let transactionType: Transaction
    
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
        Sub(name: "Saving",
            price: 100,
            recurrence: .monthly,
            dueEvery: Date(),
            transactionType: .saving),
        Sub(name: "Apple Music",
            price: 9.99,
            recurrence: .monthly,
            dueEvery: Date(),
            transactionType: .debit),
        Sub(name: "Gift",
            price: 15.99,
            recurrence: .monthly,
            dueEvery: Date(),
            transactionType: .credit)
    ]
}

#endif
