//
//  AppError.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation

struct AppError: Identifiable {
    
    // MARK: - Properties
    
    let id = UUID()
    
    let title = "Whoops ..."
    let message: String
    let dimissActionTitle = "Got it!"
    
    // MARK: - Lifecycle
    
    init(error: Error) {
        self.message = error.localizedDescription
    }
}
