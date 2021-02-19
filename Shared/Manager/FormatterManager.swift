//
//  FormatterManager.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 18/02/2021.
//

import Foundation
import Injectable

final class FormatterManager: Injectable {
    
    // MARK: - Properties
    
    private let numberFormatter = NumberFormatter()
    private let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle
    
    init() {
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
    }
    
    // MARK: - Methods
    
    func doubleToString(value: Double, isCurrency: Bool) -> String? {
        numberFormatter.numberStyle = isCurrency ? .currency : .decimal

        return numberFormatter.string(from: value as NSNumber)
    }
    
    func stringToDouble(value: String) -> Double? {
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.number(from: value)?.doubleValue
    }
    
    func dateToString(date: Date) -> String? {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
}
