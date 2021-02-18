//
//  AppDependency.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Injectable

final class AppDependency {
    
    // MARK: - Properties
    
    private let billingManager: BillingManager
    private let formatterManager: FormatterManager
    private let subWorker: SubWorker
    
    // MARK: - Lifecycle
    
    init() {
        billingManager = BillingManager()
        formatterManager = FormatterManager()
        subWorker = SubWorker(realmService: RealmService(), billingManager: billingManager)

        registerDependencies()
    }
    
    // MARK: - Methods
    
    private func registerDependencies() {
        let resolver = Resolver.shared
        
        resolver.register(billingManager)
        resolver.register(formatterManager)
        resolver.register(subWorker)
    }
}

