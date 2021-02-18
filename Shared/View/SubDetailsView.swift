//
//  SubDetailsView.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 18/02/2021.
//

import SwiftUI

struct SubDetailsView: View {
    
    // MARK: - Properties
    
    let sub: Sub
    
    // MARK: - Body
    
    var body: some View {
        Text("\(sub.price, specifier: "%.2f")")
            .navigationTitle(sub.name)
    }
    
}

#if DEBUG

struct SubDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SubDetailsView(sub: Sub.one)
    }
}

#endif
