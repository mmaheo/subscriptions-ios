//
//  SubWorker.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import RxSwift
import Injectable

final class SubWorker: Injectable {
    
    // MARK: - Properties
    
    private let realmService: RealmService
    
    // MARK: - Lifecycle
    
    init(realmService: RealmService) {
        self.realmService = realmService
    }
    
    // MARK: - Methods
    
    func create(sub: Sub) -> Completable {
        let subRealm = SubRealm(sub: sub)
        
        return realmService.create(element: subRealm)
    }
    
    func fetchSubs() -> Single<[Sub]> {
        realmService
            .read(ofType: SubRealm.self, sortedByKeyPath: "createdAt", ascending: false)
            .map{ Array($0).map { Sub(subRealm: $0) } }
    }
    
}
