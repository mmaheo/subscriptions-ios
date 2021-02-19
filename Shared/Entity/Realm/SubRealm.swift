//
//  SubRealm.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Foundation
import RealmSwift

final class SubRealm: Object {
    
    // MARK: - Properties
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var recurrence = Sub.Recurrence.monthly.rawValue
    @objc dynamic var dueEvery = Date()
    @objc dynamic var transactionType = Sub.Transaction.debit.rawValue
    
    // MARK: - Lifecycle
    
    convenience init(sub: Sub) {
        self.init()
        
        self.id = sub.id
        self.name = sub.name
        self.price = sub.price
        self.recurrence = sub.recurrence.rawValue
        self.dueEvery = sub.dueEvery
        self.transactionType = sub.transactionType.rawValue
    }
    
    // MARK: - Methods
    
    override class func primaryKey() -> String? {
        "id"
    }

}
