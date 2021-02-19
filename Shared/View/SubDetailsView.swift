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
        AddOrUpdateSubFormComponent(type: .update,
                                    validateAction: { updateSubscriptionAction() },
                                    name: $sub.name,
                                    price: $sub.price,
                                    recurrence: $sub.recurrence,
                                    transaction: $sub.transaction,
                                    dueEvery: $sub.dueEvery,
                                    isNotificationEnabled: $sub.isNotificationEnabled,
                                    notificationTime: $sub.notificationTime,
                                    remindDaysBefore: $sub.remindDaysBefore)
        .navigationTitle("details")
    }
    
    // MARK: - Methods
    
    private func updateSubscriptionAction() {
        subStore.dispatch(action: .update(sub: sub))
        
        presentationMode.wrappedValue.dismiss()
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
