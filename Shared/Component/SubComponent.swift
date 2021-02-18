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
        VStack {
            HStack {
                Spacer()
                
                Text("\(sub.daysLeftBeforeNextBilling) \(sub.daysLeftBeforeNextBilling > 1 ? "days" : "day") left")
                    .font(.caption)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(sub.name)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    sub.priceWithCurrency.map {
                        Text($0)
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                    }
                }
                
                Spacer()
            }
        }
        .frame(height: 80)
        .foregroundColor(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
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
