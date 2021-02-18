//
//  BillingManager.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 18/02/2021.
//

import Foundation
import Injectable

final class BillingManager: Injectable {
    
    // MARK: - Properties
    
    private let calendar = Calendar.current
    
    // MARK: - Methods
    
    func daysLeftBeforeNextBilling(sub: Sub) -> Int {
        guard let nextBilling = nextBillingDate(dueEvery: sub.dueEvery, recurrence: sub.recurrence) else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        let nextBillingDate = calendar.startOfDay(for: nextBilling)
        
        let components = calendar.dateComponents([.day], from: today, to: nextBillingDate)
                        
        return components.day ?? 0
    }
    
    func monthlyPrice(sub: Sub) -> Double {
        switch sub.recurrence {
        case .weekly:
            return sub.price * 52 / 12
        case .monthly:
            return sub.price
        case .yearly:
            return sub.price / 12
        }
    }
    
    // MARK: - Private Methods
    
    private func nextBillingDate(dueEvery: Date?, recurrence: Sub.Recurrence) -> Date? {
        guard let dueEvery = dueEvery else { return nil }
        
        let today = calendar.startOfDay(for: Date())
        let dueAt = calendar.startOfDay(for: dueEvery)
        
        if dueAt >= today {
            return dueEvery
        }
        
        switch recurrence {
        case .weekly:
            return nextBillingDate(dueEvery: calendar.date(byAdding: .day, value: 7, to: dueEvery), recurrence: recurrence)
        case .monthly:
            return nextBillingDate(dueEvery: calendar.date(byAdding: .month, value: 1, to: dueEvery), recurrence: recurrence)
        case .yearly:
            return nextBillingDate(dueEvery: calendar.date(byAdding: .year, value: 1, to: dueEvery), recurrence: recurrence)
        }
    }
    
}
