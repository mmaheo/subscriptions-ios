//
//  AddAddSubView.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct AddSubView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var subStore: SubStore
    
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var price: String = ""
    @State private var recurrence = Sub.Recurrence.monthly
    @State private var dueEvery = Date()
    @State private var transaction = Sub.Transaction.debit
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                makeGeneralSectionView()
                
                Button("add_subscription") {
                    addNewSubscriptionAction()
                }
                .disabled(!subStore.isFormValid(price: price, name: name))
            }
            .navigationTitle("new_subscription")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        cancelAction()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("add") {
                        addNewSubscriptionAction()
                    }
                    .disabled(!subStore.isFormValid(price: price, name: name))
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func addNewSubscriptionAction() {
        subStore.dispatch(action: .addSub(name: name,
                                          price: price,
                                          recurrence: recurrence,
                                          dueEvery: dueEvery,
                                          transaction: transaction))
        cancelAction()
    }
    
    private func cancelAction() {
        isPresented = false
    }
    
    // MARK: - Make views methods
    
    private func makeGeneralSectionView() -> some View {
        Section(header: Text("General")) {
            TextField("name", text: $name)
            TextField("price", text: $price)
                .keyboardType(.decimalPad)
            Picker("recurrence", selection: $recurrence) {
                ForEach(Sub.Recurrence.allCases, id: \.self) {
                    Text($0.localized)
                }
            }
            Picker("transaction", selection: $transaction) {
                ForEach(Sub.Transaction.allCases, id: \.self) {
                    Text($0.localized)
                }
            }
            DatePicker(String(NSLocalizedString("next_billing", comment: "")),
                       selection: $dueEvery,
                       in: Date()...,
                       displayedComponents: .date)
        }
    }
}

#if DEBUG

struct AddSubView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubView(isPresented: .constant(true))
            .environmentObject(subStorePreview)
    }
}

#endif

