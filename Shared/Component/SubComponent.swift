//
//  SubComponent.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI
import Injectable
import Foundation

struct SubComponent: View {
    
    // MARK: - Properties
    
    @Inject private var billingManager: BillingManager
    @Inject private var formatterManager: FormatterManager
    
    let sub: Sub
    
    private var daysLeftBeforeNextBilling: Int {
        billingManager.daysLeftBeforeNextBilling(sub: sub)
    }
    
    private var price: String? {
        formatterManager.doubleToString(value: sub.price, isCurrency: true)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            makeDaysLeftView()
            
            makePriceView()
        }
        .frame(height: 80)
        .foregroundColor(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: sub.transactionType.gradientColors),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
        .cornerRadius(8)
    }
    
    // MARK: - Private make views methods
    
    private func makeDaysLeftView() -> some View {
        let message: String
        
        if daysLeftBeforeNextBilling > 1 {
            message = String(format: NSLocalizedString("days_left", comment: ""), daysLeftBeforeNextBilling)
        } else {
            message = String(format: NSLocalizedString("day_left", comment: ""), daysLeftBeforeNextBilling)
        }
        
        return HStack {
            Spacer()
            
            Text(message)
                .font(.caption)
        }
    }
    
    private func makePriceView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                
                Text(sub.name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                price.map {
                    Text($0)
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            
            Spacer()
        }
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
