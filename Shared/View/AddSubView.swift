//
//  AddAddSubView.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct AddSubView: View {
    
    // MARK: - Properties
    
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var price: String = ""
    @State private var recurrence = Sub.Recurrence.monthly
    @State private var dueEvery = Date()
    
    @EnvironmentObject private var subStore: SubStore
    
    private var isFormValid: Bool {
        guard let price = Double(price),
              price > 0,
              !name.isEmpty
        else { return false }
        
        return true
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                makeGeneralSectionView()
                
                Button("Add new subscription") {
                    addNewSubscriptionAction()
                }
                .disabled(!isFormValid)
            }
            .navigationTitle("Add subscription")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancelAction()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addNewSubscriptionAction()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func addNewSubscriptionAction() {
        subStore.dispatch(action: .addSub(name: name, price: price, recurrence: recurrence, dueEvery: dueEvery))
        cancelAction()
    }
    
    private func cancelAction() {
        isPresented = false
    }
    
    // MARK: - Make views methods
    
    private func makeGeneralSectionView() -> some View {
        Section(header: Text("General")) {
            TextField("Name", text: $name)
            TextField("Price", text: $price)
                .keyboardType(.decimalPad)
            Picker("Reccurence", selection: $recurrence) {
                ForEach(Sub.Recurrence.allCases, id: \.self) {
                    Text($0.localized)
                }
            }
            DatePicker("Next billing", selection: $dueEvery, in: Date()..., displayedComponents: .date)
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

