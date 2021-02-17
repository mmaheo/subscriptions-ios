//
//  SubComponent.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct SubComponent: View {
    
    // MARK: - Properties
    
    let name: String
    let price: Double
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(price, specifier: "%.2f")")
                    .font(.headline)
                
                Text(name)
                    .font(.subheadline)
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.red)
        .cornerRadius(8)
    }
}

#if DEBUG

struct SubComponent_Previews: PreviewProvider {
    static var previews: some View {
        SubComponent(name: "iCloud", price: 9.99)
            .previewLayout(.sizeThatFits)
    }
}

#endif
