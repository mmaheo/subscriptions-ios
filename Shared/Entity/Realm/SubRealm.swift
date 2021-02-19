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
    @objc dynamic var transaction = Sub.Transaction.debit.rawValue
    @objc dynamic var isNotificationEnabled: Bool = true
    @objc dynamic var notificationTime: Date = Date()
    @objc dynamic var remindDaysBefore: Int = 1
    
    // MARK: - Lifecycle
    
    convenience init(sub: Sub) {
        self.init()
        
        self.id = sub.id
        self.name = sub.name
        self.price = sub.price
        self.recurrence = sub.recurrence.rawValue
        self.dueEvery = sub.dueEvery
        self.transaction = sub.transaction.rawValue
        self.isNotificationEnabled = sub.isNotificationEnabled
        self.notificationTime = sub.notificationTime
        self.remindDaysBefore = sub.remindDaysBefore
    }
    
    // MARK: - Methods
    
    override class func primaryKey() -> String? {
        "id"
    }

}
