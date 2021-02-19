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
    @State private var price: Double = 0
    @State private var recurrence = Sub.Recurrence.monthly
    @State private var dueEvery = Date()
    @State private var transaction = Sub.Transaction.debit
    @State private var isNotificationEnabled = true
    @State private var notificationTime = Date()
    @State private var remindDaysBefore = 1
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            AddOrUpdateSubFormComponent(type: .add,
                                        validateAction: { addNewSubscriptionAction() },
                                        name: $name,
                                        price: $price,
                                        recurrence: $recurrence,
                                        transaction: $transaction,
                                        dueEvery: $dueEvery,
                                        isNotificationEnabled: $isNotificationEnabled,
                                        notificationTime: $notificationTime,
                                        remindDaysBefore: $remindDaysBefore)
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
                                          transaction: transaction,
                                          isNotificationEnabled: isNotificationEnabled,
                                          notificationTime: notificationTime,
                                          remindDaysBefore: remindDaysBefore))
        cancelAction()
    }
    
    private func cancelAction() {
        isPresented = false
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

