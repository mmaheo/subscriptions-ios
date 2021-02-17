//
//  SubscriptionsApp.swift
//  Shared
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

@main
struct SubscriptionsApp: App {
    
    // MARK: - Properties
    
    private let subStore = SubStore()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            SubView()
                .environmentObject(subStore)
        }
    }
}
