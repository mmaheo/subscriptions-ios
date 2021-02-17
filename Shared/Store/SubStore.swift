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
    case addSub
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
        case .addSub:
            addSubAction()
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
    
    private func addSubAction() {
        let subToAdd = Sub(name: "toto", price: 1000)
        
        subWorker
            .create(sub: subToAdd)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                
                self.subs.append(subToAdd)
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

