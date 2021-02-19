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
    @Published var transaction: Transaction
    @Published var isNotificationEnabled: Bool
    @Published var notificationTime: Date
    @Published var remindDaysBefore: Int
    
    // MARK: - Lifecycle
    
    init(name: String,
         price: Double,
         recurrence: Recurrence,
         dueEvery: Date,
         transaction: Transaction,
         isNotificationEnabled: Bool = true,
         notificationTime: Date = Date(),
         remindDaysBefore: Int = 1) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
        self.recurrence = recurrence
        self.dueEvery = dueEvery
        self.transaction = transaction
        self.isNotificationEnabled = isNotificationEnabled
        self.notificationTime = notificationTime
        self.remindDaysBefore = remindDaysBefore
    }
    
    init?(subRealm: SubRealm) {
        self.id = subRealm.id
        self.name = subRealm.name
        self.price = subRealm.price
        
        guard let recurrence = Recurrence(rawValue: subRealm.recurrence) else { return nil }
        self.recurrence = recurrence
        
        self.dueEvery = subRealm.dueEvery
        
        guard let transaction = Transaction(rawValue: subRealm.transaction) else { return nil }
        self.transaction = transaction
        
        self.isNotificationEnabled = subRealm.isNotificationEnabled
        self.notificationTime = subRealm.notificationTime
        self.remindDaysBefore = subRealm.remindDaysBefore
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
            transaction: .saving,
            isNotificationEnabled: false),
        Sub(name: "Apple Music",
            price: 15.99,
            recurrence: .monthly,
            dueEvery: Date().addingTimeInterval(60 * 60 * 24 * 1),
            transaction: .debit),
        Sub(name: "Refund",
            price: 4.99,
            recurrence: .monthly,
            dueEvery: Date().addingTimeInterval(60 * 60 * 24 * 40),
            transaction: .credit)
    ]
}

#endif
