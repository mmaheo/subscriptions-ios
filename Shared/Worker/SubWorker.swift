//
//  SubWorker.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import RxSwift
import Injectable
import OSLog

final class SubWorker: Injectable {
    
    // MARK: - Properties
    
    private let realmService: RealmService
    private let billingManager: BillingManager
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(realmService: RealmService, billingManager: BillingManager) {
        self.realmService = realmService
        self.billingManager = billingManager
        
        #if DEBUG
        populateData()
        #endif
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
    
    func delete(sub: Sub) -> Completable {
        realmService.delete(ofType: SubRealm.self, forPrimaryKey: sub.id)
    }
    
    func update(sub: Sub) -> Completable {
        let subRealm = SubRealm(sub: sub)
        
        return realmService.update(element: subRealm)
    }
    
    // MARK: - Private Methods
    
    private func sortByNextBillingAndAToZ(sub1: Sub, sub2: Sub) -> Bool {
        let nextBillingSub1 = billingManager.daysLeftBeforeNextBilling(sub: sub1)
        let nextBillingSub2 = billingManager.daysLeftBeforeNextBilling(sub: sub2)
        
        if nextBillingSub1 != nextBillingSub2 {
            return nextBillingSub1 < nextBillingSub2
        }
        
        return sub1.name.localizedStandardCompare(sub2.name) == .orderedAscending
    }
    
    private func populateData() {
        let subsRealm = Sub.list.map { SubRealm(sub: $0) }
        
        realmService
            .deleteAll()
            .andThen(realmService.create(elements: subsRealm))
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: {
                Logger.realm.debug("Populate data complete")
            }, onError: { error in
                Logger.realm.debug("Populate data error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
}
