//
//  SubDetailsView.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 19/02/2021.
//

import SwiftUI

struct SubDetailsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var subStore: SubStore
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private(set) var sub: Sub
    
    // MARK: - Body
    
    var body: some View {
        Form {
            makeGeneralSectionView()
            
            Button("Update subscription") {
                updateSubscriptionAction()
            }
            .disabled(!subStore.isFormValid(sub: sub))
        }
        .navigationTitle("Details")
    }
    
    // MARK: - Methods
    
    private func updateSubscriptionAction() {
        subStore.dispatch(action: .update(sub: sub))
        
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - Make views methods
    
    private func makeGeneralSectionView() -> some View {
        let priceProxy = Binding(
            get: { subStore.convertPriceToString(price: sub.price) },
            set: { sub.price = subStore.convertPriceToDouble(price: $0) }
        )
        
        return Section(header: Text("General")) {
            TextField("Name", text: $sub.name)
            TextField("Price", text: priceProxy)
                .keyboardType(.decimalPad)
            Picker("Recurrence", selection: $sub.recurrence) {
                ForEach(Sub.Recurrence.allCases, id: \.self) {
                    Text($0.localized)
                }
            }
            Picker("Transaction", selection: $sub.transactionType) {
                ForEach(Sub.Transaction.allCases, id: \.self) {
                    Text($0.localized)
                }
            }
            DatePicker("Next billing", selection: $sub.dueEvery, in: Date()..., displayedComponents: .date)
        }
    }
}

#if DEBUG

struct SubDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SubDetailsView(sub: Sub.one)
            .environmentObject(subStorePreview)
    }
}

#endif
