//
//  FormatterManager.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 18/02/2021.
//

import Foundation

final class FormatterManager {
    
    // MARK: - Properties
    
    static let shared = FormatterManager()
    
    private let numberFormatter = NumberFormatter()
    
    // MARK: - Lifecycle
    
    private init() {
        guard let preferredIdentifier = Locale.preferredLanguages.first else { return }
        
        numberFormatter.locale = Locale(identifier: preferredIdentifier)
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
}
