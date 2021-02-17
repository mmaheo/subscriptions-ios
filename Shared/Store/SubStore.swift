//
//  SubStore.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import Combine

enum SubStoreAction {
    case fetchSubs
}

final class SubStore: ObservableObject {

    // MARK: - Properties
    
    @Published private(set) var subs: [Sub]
    
    // MARK: - Lifecycle
    
    init(subs: [Sub] = []) {
        self.subs = subs
    }
    
    // MARK: - Actions
    
    func dispatch(action: SubStoreAction) {
        
    }
    
}

#if DEBUG

let subStorePreview = SubStore(subs: Sub.list)

#endif

