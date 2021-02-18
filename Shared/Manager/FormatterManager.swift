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
