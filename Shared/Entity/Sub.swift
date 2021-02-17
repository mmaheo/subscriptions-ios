//
//  Sub.swift
//  Subscriptions (iOS)
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation

struct Sub: Identifiable {
    
    let id = UUID()
    let name: String
    let price: Float
    
    
}

#if DEBUG

extension Sub {
    static let list = [
        Sub(name: "iCloud", price: 0.99),
        Sub(name: "Apple Music", price: 9.99)
    ]
}

#endif
