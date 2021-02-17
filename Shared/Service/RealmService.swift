//
//  DatabaseService.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import RealmSwift
import RxSwift
import OSLog

protocol RealmServiceContract {
    func create<Element: Object>(element: Element) -> Completable
    func read<Element: Object>(ofType type: Element.Type) -> Single<Results<Element>>
}

final class RealmService: RealmServiceContract {
    
    // MARK: - Properties
    
    private let realmConfig: Realm.Configuration

    // MARK: - Lifecycle
    
    init() {
        realmConfig = Realm.Configuration()
        
        if let fileURL = realmConfig.fileURL?.absoluteString {
            Logger.realm.info("Realm file: \(fileURL)")
        }
    }
    
    // MARK: - Methods
    
    func create<Element: Object>(element: Element) -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self,
                  let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            do {
                try realm.write {
                    realm.add(element)
                }
                
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func read<Element: Object>(ofType type: Element.Type) -> Single<Results<Element>> {
        Single.create { [weak self] (single) in
            guard let self = self,
                let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            single(.success(realm.objects(type)))
            
            return Disposables.create()
        }
    }
    
}
