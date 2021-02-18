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
            .read(ofType: SubRealm.self)
            .map{ Array($0)
                .compactMap { Sub(subRealm: $0) }
                .sorted(by: self.sortByNextBillingAndAToZ(sub1:sub2:))
            }
    }
    
    // MARK: - Private Methods
    
    private func sortByNextBillingAndAToZ(sub1: Sub, sub2: Sub) -> Bool {
        let nextBillingSub1 = sub1.daysLeftBeforeNextBilling
        let nextBillingSub2 = sub2.daysLeftBeforeNextBilling
        
        if nextBillingSub1 != nextBillingSub2 {
            return nextBillingSub1 > nextBillingSub2
        }
        
        return sub1.name.localizedStandardCompare(sub2.name) == .orderedAscending
    }
    
}
