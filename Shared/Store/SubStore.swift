//
//  SubStore.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Combine
import Injectable
import RxSwift
import OSLog

enum SubStoreAction {
    case fetchSubs
    case addSub(name: String, price: String, recurrence: Sub.Recurrence, dueEvery: Date)
}

final class SubStore: ObservableObject {

    // MARK: - Properties
    
    @Published private(set) var subs: [Sub]
    @Published var error: AppError?
    
    @Inject private var subWorker: SubWorker
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    init(subs: [Sub] = []) {
        self.subs = subs
    }
    
    // MARK: - Actions
    
    func dispatch(action: SubStoreAction) {
        switch action {
        case .fetchSubs:
            fetchSubsAction()
        case let .addSub(name, price, recurrence, dueEvery):
            addSubAction(name: name, price: price, recurrence: recurrence, dueEvery: dueEvery)
        }
    }
    
    // MARK: - Private Actions
    
    private func fetchSubsAction() {
        subWorker
            .fetchSubs()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] subs in
                guard let self = self else { return }
                
                self.subs = subs
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                
                self.error = AppError(error: error)
            }
            .disposed(by: disposeBag)
    }
    
    private func addSubAction(name: String, price: String, recurrence: Sub.Recurrence, dueEvery: Date) {
        guard let priceInDouble = Double(price) else { return }
        
        let subToAdd = Sub(name: name, price: priceInDouble, recurrence: recurrence, dueEvery: dueEvery)
        
        subWorker
            .create(sub: subToAdd)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                
                self.subs.insert(subToAdd, at: 0)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                
                self.error = AppError(error: error)
            })
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG

let subStorePreview = SubStore(subs: Sub.list)

#endif

