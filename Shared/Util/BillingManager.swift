//
//  BillingManager.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 18/02/2021.
//

import Foundation
import SwiftDate

final class BillingManager {
    
    // MARK: - Properties
    
    static let shared = BillingManager()
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Methods
    
    func daysLeftBeforeNextBilling(sub: Sub) -> Int {
        let nextBilling = nextBillingDate(dueEvery: sub.dueEvery, recurrence: sub.recurrence)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let nextBillingDate = calendar.startOfDay(for: nextBilling)
        let components = calendar.dateComponents([.day], from: today, to: nextBillingDate)
                        
        return components.day ?? 0
    }
    
    // MARK: - Private Methods
    
    private func nextBillingDate(dueEvery: Date, recurrence: Sub.Recurrence) -> Date {
        if dueEvery.isAfterDate(Date(), orEqual: true, granularity: .day) {
            return dueEvery
        }
        
        switch recurrence {
        case .weekly:
            return nextBillingDate(dueEvery: dueEvery + 7.days, recurrence: recurrence)
        case .monthly:
            return nextBillingDate(dueEvery: dueEvery + 1.months, recurrence: recurrence)
        case .yearly:
            return nextBillingDate(dueEvery: dueEvery + 1.years, recurrence: recurrence)
        }
    }
    
}
