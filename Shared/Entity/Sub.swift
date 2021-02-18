//
//  Sub.swift
//  Subscriptions (iOS)
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation

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
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let price: Double
    let recurrence: Recurrence
    let dueEvery: Date
    
    // MARK: - Lifecycle
    
    init(name: String, price: Double, recurrence: Recurrence, dueEvery: Date) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
        self.recurrence = recurrence
        self.dueEvery = dueEvery
    }
    
    init?(subRealm: SubRealm) {
        self.id = subRealm.id
        self.name = subRealm.name
        self.price = subRealm.price
        
        guard let recurrence = Recurrence(rawValue: subRealm.recurrence) else { return nil }
        self.recurrence = recurrence
        
        self.dueEvery = subRealm.dueEvery
    }
    
}

#if DEBUG

extension Sub {
    static let one = list[0]
    
    static let list = [
        Sub(name: "iCloud", price: 0.99, recurrence: .monthly, dueEvery: Date()),
        Sub(name: "Apple Music", price: 9.99, recurrence: .monthly, dueEvery: Date())
    ]
}

#endif
