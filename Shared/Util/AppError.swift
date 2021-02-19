//
//  AppError.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation
import SwiftUI
import OSLog

struct AppError: Identifiable {
    
    // MARK: - Properties
    
    let id = UUID()
    
    let title = "Whoops ..."
    let message: String
    let dimissActionTitle: LocalizedStringKey = "error_dimiss_action_title"
    
    // MARK: - Lifecycle
    
    init(error: Error) {
        self.message = error.localizedDescription
        
        Logger.popup.error("Error occured: \(error.localizedDescription)")
    }
}
