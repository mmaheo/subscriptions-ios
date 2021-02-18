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
    case delete(sub: Sub)
}

final class SubStore: ObservableObject {

    // MARK: - Properties
    
    @Inject private var subWorker: SubWorker
    @Inject private var billingManager: BillingManager
    @Inject private var formatterManager: FormatterManager
    
    @Published private(set) var subs: [Sub] {
        didSet {
            let amount = Double(subs.reduce(0) { $0 + billingManager.monthlyPrice(sub: $1) })
            
            totalAmount = formatterManager.doubleToString(value: amount, isCurrency: true)
        }
    }
    @Published private(set) var totalAmount: String?
    @Published var error: AppError?
    
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
        case let .delete(sub):
            deleteAction(sub: sub)
        }
    }
    
    // MARK: - Methods
    
    func isFormValid(price: String, name: String) -> Bool {
        guard let price = formatterManager.stringToDouble(value: price),
              price > 0,
              !name.isEmpty
        else { return false }

        return true
    }
    
    // MARK: - Private Actions
    
    private func fetchSubsAction() {
        Logger.userAction.log("Fetch subscriptions")
        
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
        Logger.userAction.log("Add subscriptions")
        
        guard let priceInDouble = formatterManager.stringToDouble(value: price) else { return }
        
        let subToAdd = Sub(name: name, price: priceInDouble, recurrence: recurrence, dueEvery: dueEvery)
        
        subWorker
            .create(sub: subToAdd)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                
                self.fetchSubsAction()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                
                self.error = AppError(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteAction(sub: Sub) {
        Logger.userAction.log("Delete subscriptions")
        
        subWorker
            .delete(sub: sub)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                guard let self = self else { return }
                
                self.fetchSubsAction()
            } onError: {[weak self] error in
                guard let self = self else { return }
                
                self.error = AppError(error: error)
            }
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG

let subStorePreview = SubStore(subs: Sub.list)

#endif

