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
    
    var daysLeft: Int? {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        let dueDate = calendar.startOfDay(for: dueEvery)

        let daysLeft = calendar.dateComponents([.day], from: today, to: dueDate).day
        
        // If days left is less than 0, we must calculate the next billing. IE: (7 days, 1 month, 1 year).
        // Otherwise, return days left.
        if let daysLeft = daysLeft, daysLeft < 0 {
            let nextDueDate: Date?
            
            switch recurrence {
            case .weekly:
                nextDueDate = calendar.date(byAdding: .day, value: 7, to: dueDate)
            case .monthly:
                nextDueDate = calendar.date(byAdding: .month, value: 1, to: dueDate)
            case .yearly:
                nextDueDate = calendar.date(byAdding: .year, value: 1, to: dueDate)
            }
            
            if let nextDueDate = nextDueDate {
                return calendar.dateComponents([.day], from: today, to: nextDueDate).day
            }
            
            return nil
        }
        
        return daysLeft
    }
    
    var wrappedDaysLeft: Int {
        daysLeft ?? 0
    }
    
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
