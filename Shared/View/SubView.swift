//
//  SubView.swift
//  Shared
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct SubView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var subStore: SubStore
    
    // MARK: - Body
    
    var body: some View {
        List(subStore.subs) { sub in
            HStack {
                Text(sub.name)
                Spacer()
                Text("\(sub.price) $")
            }
        }
    }
}

#if DEBUG

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView()
            .environmentObject(subStorePreview)
    }
}

#endif
