//
//  AppDependency.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Injectable

final class AppDependency {
    
    // MARK: - Properties
    
    private let subWorker: SubWorker
    
    // MARK: - Lifecycle
    
    init() {
        self.subWorker = SubWorker(realmService: RealmService())

        registerDependencies()
    }
    
    // MARK: - Methods
    
    private func registerDependencies() {
        let resolver = Resolver.shared
        
        resolver.register(subWorker)
    }
}

