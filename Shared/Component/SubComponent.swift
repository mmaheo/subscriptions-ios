//
//  SubComponent.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct SubComponent: View {
    
    // MARK: - Properties
    
    let sub: Sub
    
    // MARK: - Body
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(sub.name)
                    .font(.headline)
                
                Text(sub.recurrence.localized)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(sub.price, specifier: "%.2f")")
                    .font(.headline)
                
                sub.daysLeft.map {
                    Text("\($0) \($0 > 1 ? "days" : "day") left")
                        .font(.caption)
                }
            }
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
        SubComponent(sub: Sub.one)
            .previewLayout(.sizeThatFits)
    }
}

#endif
