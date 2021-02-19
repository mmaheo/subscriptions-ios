//
//  DatabaseService.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import RealmSwift
import RxSwift
import OSLog

final class RealmService {
    
    // MARK: - Properties
    
    private let realmConfig: Realm.Configuration

    // MARK: - Lifecycle
    
    init() {
        realmConfig = Realm.Configuration()
        
        if let fileURL = realmConfig.fileURL?.absoluteString {
            Logger.realm.debug("Realm file: \(fileURL)")
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
                
                Logger.realm.log("Create object with success")
                
                completable(.completed)
            } catch {
                Logger.realm.error("Fail to create object. \(error.localizedDescription)")
                
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func create<Element: Object>(elements: [Element]) -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self,
                  let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            do {
                try realm.write {
                    realm.add(elements)
                }
                
                Logger.realm.log("Create objects with success")
                
                completable(.completed)
            } catch {
                Logger.realm.error("Fail to create objects. \(error.localizedDescription)")
                
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func read<Element: Object>(ofType type: Element.Type,
                               sortedByKeyPath keyPath: String? = nil,
                               ascending: Bool = true) -> Single<Results<Element>> {
        Single.create { [weak self] (single) in
            guard let self = self,
                let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            let objects = realm.objects(type)
            
            if let keyPath = keyPath {
                Logger.realm.log("Read objects and sort them")
                
                single(.success(objects.sorted(byKeyPath: keyPath, ascending: ascending)))
            } else {
                Logger.realm.log("Read objects")
                
                single(.success(objects))
            }
            
            return Disposables.create()
        }
    }
    
    func delete<Element: Object>(ofType type: Element.Type,
                                 forPrimaryKey primaryKey: String) -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self,
                  let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            do {
                try realm.write {
                    if let elementToDelete = realm.object(ofType: type, forPrimaryKey: primaryKey) {
                        realm.delete(elementToDelete)
                    }
                }
                
                Logger.realm.log("Delete object with success")
                
                completable(.completed)
            } catch {
                Logger.realm.error("Failed to delete object")
                
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Completable {
        Completable.create { [weak self] completable in
            guard let self = self,
                  let realm = try? Realm(configuration: self.realmConfig)
            else { return Disposables.create() }
            
            do {
                try realm.write {
                    realm.deleteAll()
                }
                
                Logger.realm.log("Delete all with success")
                
                completable(.completed)
            } catch {
                Logger.realm.error("Failed to delete all")
                
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
}
