//
//  AddOrUpdateSubFormComponent.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 19/02/2021.
//

import SwiftUI
import Injectable

struct AddOrUpdateSubFormComponent: View {
    
    enum `Type` {
        case add, update
    }
    
    // MARK: - Properties
    
    @EnvironmentObject private var subStore: SubStore
    @Inject private var formatterManager: FormatterManager
    
    let type: Type
    let validateAction: () -> ()
    
    @Binding var name: String
    @Binding var price: Double
    @Binding var recurrence: Sub.Recurrence
    @Binding var transaction: Sub.Transaction
    @Binding var dueEvery: Date
    @Binding  var isNotificationEnabled: Bool
    @Binding  var notificationTime: Date
    @Binding  var remindDaysBefore: Int

    private var notificationSummary: String? {
        guard let notificationTime = formatterManager.dateToString(date: notificationTime) else { return nil }
        
        return String(format: NSLocalizedString("notification_will_be_sent_days_before_at", comment: ""),
                      remindDaysBefore, notificationTime)
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            makeGeneralSectionView()
            makeNotificationSectionView()
            makeValidateButtonView()
        }
    }
    
    // MARK: - Make views
    
    private func makeGeneralSectionView() -> some View {
        let priceProxy = Binding(
            get: { subStore.convertPriceToString(price: price) },
            set: { price = subStore.convertPriceToDouble(price: $0) }
        )
        
        return Section(header: Text("general")) {
            TextField("name", text: $name)
            TextField("price", text: priceProxy)
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
    
    private func makeNotificationSectionView() -> some View {
        Section(header: Text("notification")) {
            Toggle("notification", isOn: $isNotificationEnabled)
            
            if isNotificationEnabled {
                DatePicker(String(NSLocalizedString("send_at", comment: "")),
                           selection: $notificationTime,
                           displayedComponents: .hourAndMinute)
                
                Stepper("days_before", value: $remindDaysBefore, in: 0...100)
                
                notificationSummary.map {
                    Text($0)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func makeValidateButtonView() -> some View {
        Button(type == .add ? "add_subscription" : "update_subscription") {
            validateAction()
        }
        .disabled(!subStore.isFormValid(price: price, name: name))
    }
    
}

#if DEBUG

struct AddOrUpdateSubFormComponent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddOrUpdateSubFormComponent(type: .add,
                                        validateAction: { },
                                        name: .constant(""),
                                        price: .constant(0),
                                        recurrence: .constant(Sub.Recurrence.monthly),
                                        transaction: .constant(Sub.Transaction.debit),
                                        dueEvery: .constant(Date()),
                                        isNotificationEnabled: .constant(true),
                                        notificationTime: .constant(Date()),
                                        remindDaysBefore: .constant(1))
            
            AddOrUpdateSubFormComponent(type: .update,
                                        validateAction: { },
                                        name: .constant(Sub.one.name),
                                        price: .constant(Sub.one.price),
                                        recurrence: .constant(Sub.one.recurrence),
                                        transaction: .constant(Sub.one.transaction),
                                        dueEvery: .constant(Sub.one.dueEvery),
                                        isNotificationEnabled: .constant(Sub.one.isNotificationEnabled),
                                        notificationTime: .constant(Sub.one.notificationTime),
                                        remindDaysBefore: .constant(Sub.one.remindDaysBefore))
                .preferredColorScheme(.dark)
        }
        .environmentObject(subStorePreview)
    }
}

#endif
