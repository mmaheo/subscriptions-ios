//
//  SubView.swift
//  Shared
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct SubView: View {
    
    // MARK: - Properties
    
    @State private var isShowingAddSubView = false
    
    @EnvironmentObject private var subStore: SubStore
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(subStore.subs) {
                        SubComponent(sub: $0)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .onAppear {
                subStore.dispatch(action: .fetchSubs)
            }
            .alert(item: $subStore.error) { error in
                Alert(title: Text(error.title),
                      message: Text(error.message),
                      dismissButton: .default(Text(error.dimissActionTitle)))
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                Button(action: {
                    isShowingAddSubView.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .sheet(isPresented: $isShowingAddSubView) {
                AddSubView(isPresented: $isShowingAddSubView)
            }
        }
    }
}

#if DEBUG

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView()
            .environmentObject(subStorePreview)
    }
}

#endif
