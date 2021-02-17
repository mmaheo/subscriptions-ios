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
    
    @EnvironmentObject private var subStore: SubStore
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General info")) {
                    TextField("Name", text: $name)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                }
                
                Button("Add new subscription") {
                    subStore.dispatch(action: .addSub(name: name, price: price))
                    isPresented = false
                }
                .disabled(Double(price) == nil)
            }
            .navigationTitle("Add subscription")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
            }
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

