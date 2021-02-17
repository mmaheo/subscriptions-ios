//
//  Sub.swift
//  Subscriptions (iOS)
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation

struct Sub: Identifiable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let price: Double
    
    // MARK: - Lifecycle
    
    init(name: String, price: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
    }
    
    init(subRealm: SubRealm) {
        self.id = subRealm.id
        self.name = subRealm.name
        self.price = subRealm.price
    }
    
}

#if DEBUG

extension Sub {
    static let list = [
        Sub(name: "iCloud", price: 0.99),
        Sub(name: "Apple Music", price: 9.99)
    ]
}

#endif
