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
    case addSub(name: String,
                price: String,
                recurrence: Sub.Recurrence,
                dueEvery: Date,
                transaction: Sub.Transaction)
    case delete(sub: Sub)
    case update(sub: Sub)
}

final class SubStore: ObservableObject {

    // MARK: - Properties
    
    @Inject private var subWorker: SubWorker
    @Inject private var billingManager: BillingManager
    @Inject private var formatterManager: FormatterManager
    
    @Published private(set) var subs: [Sub] {
        didSet {
            calculateTotalAmounts()
        }
    }
    @Published private(set) var totalAmount: String?
    @Published private(set) var totalAmountDebit: String?
    @Published private(set) var totalAmountCredit: String?
    @Published private(set) var totalAmountSaving: String?
    @Published var error: AppError?
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    init(subs: [Sub] = []) {
        self.subs = subs
        
        totalAmount = formatterManager.doubleToString(value: 0, isCurrency: true)
        totalAmountDebit = formatterManager.doubleToString(value: 0, isCurrency: true)
        totalAmountCredit = formatterManager.doubleToString(value: 0, isCurrency: true)
        totalAmountSaving = formatterManager.doubleToString(value: 0, isCurrency: true)
    }
    
    // MARK: - Actions
    
    func dispatch(action: SubStoreAction) {
        switch action {
        case .fetchSubs:
            Logger.userAction.log("Fetch subscriptions")
            
            fetchSubsAction()
        case let .addSub(name, price, recurrence, dueEvery, transaction):
            Logger.userAction.log("Add subscription")
            
            addSubAction(name: name,
                         price: price,
                         recurrence: recurrence,
                         dueEvery: dueEvery,
                         transaction: transaction)
        case let .delete(sub):
            Logger.userAction.log("Delete subscription")
            
            deleteAction(sub: sub)
        case let .update(sub):
            Logger.userAction.log("Update subscription")
            
            updateAction(sub: sub)
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
    
    func isFormValid(sub: Sub) -> Bool {
        guard sub.price > 0,
              !sub.name.isEmpty
        else { return false }

        return true
    }
    func convertPriceToDouble(price: String) -> Double {
        formatterManager.stringToDouble(value: price) ?? 0
    }
    
    func convertPriceToString(price: Double) -> String {
        formatterManager.doubleToString(value: price, isCurrency: false) ?? ""
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
    
    private func addSubAction(name: String,
                              price: String,
                              recurrence: Sub.Recurrence,
                              dueEvery: Date,
                              transaction: Sub.Transaction) {
        guard let priceInDouble = formatterManager.stringToDouble(value: price) else { return }
        
        let subToAdd = Sub(name: name,
                           price: priceInDouble,
                           recurrence: recurrence,
                           dueEvery: dueEvery,
                           transactionType: transaction)
        
        execute(completable: subWorker.create(sub: subToAdd))
    }
    
    private func deleteAction(sub: Sub) {
        execute(completable: subWorker.delete(sub: sub))
    }
    
    private func updateAction(sub: Sub) {
        execute(completable: subWorker.update(sub: sub))
    }
    
    // MARK: - Private Methods
    
    private func calculateTotalAmounts() {
        let totalAmountDebit = billingManager.totalAmount(subs: subs, transaction: .debit)
        let totalAmountCredit = billingManager.totalAmount(subs: subs, transaction: .credit)
        let totalAmountSaving = billingManager.totalAmount(subs: subs, transaction: .saving)
        let totalAmount = totalAmountDebit - totalAmountCredit

        self.totalAmountDebit = formatterManager.doubleToString(value: totalAmountDebit, isCurrency: true)
        self.totalAmountCredit = formatterManager.doubleToString(value: totalAmountCredit, isCurrency: true)
        self.totalAmountSaving = formatterManager.doubleToString(value: totalAmountSaving, isCurrency: true)
        self.totalAmount = formatterManager.doubleToString(value: totalAmount, isCurrency: true)
    }
    
    private func execute(completable: Completable) {
        completable
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

