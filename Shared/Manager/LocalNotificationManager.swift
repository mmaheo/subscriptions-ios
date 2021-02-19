//
//  LocalNotificationManager.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 19/02/2021.
//

import Injectable
import UserNotifications
import OSLog
import RxSwift

enum LocalNotificationManagerError: Error {
    case requestAuthorizationNotGranted
}

final class LocalNotificationManager: Injectable {
    
    // MARK: - Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    func schedule(title: String, body: String, date: Date, identifier: String) -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create() }
            
            self.requestAuthorization()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
                .subscribe { [weak self] in
                    guard let self = self else { return }
                    
                    let request = self.createNotificationRequest(title: title,
                                                                 body: body,
                                                                 date: date,
                                                                 identifier: identifier)
                    
                    self.userNotificationCenter
                        .add(request) { error in
                            if let error = error {
                                return completable(.error(error))
                            }
                            
                            return completable(.completed)
                        }
                } onError: { error in
                    completable(.error(error))
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func removePendingNotificationRequest(identifier: String) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization() -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create() }
            
            self.userNotificationCenter
                .requestAuthorization(options: [.alert, .sound]) { isGranted, error in
                    if let error = error {
                        return completable(.error(error))
                    }
                    
                    if !isGranted {
                        return completable(.error(LocalNotificationManagerError.requestAuthorizationNotGranted))
                    }
                    
                    return completable(.completed)
                }
            
            return Disposables.create()
        }
    }
    
    private func createNotificationRequest(title: String, body: String, date: Date, identifier: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

//        var dateComponents = DateComponents()
//        dateComponents.hour = 8
//        dateComponents.minute = 30
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
}
