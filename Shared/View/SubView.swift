//
//  SubView.swift
//  Shared
//
//  Created by Maxime Maheo on 17/02/2021.
//

import SwiftUI

struct SubView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var subStore: SubStore
    
    @State private var isShowingAddSubView = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                makeTotalAmountView()
                makeTransactionsView()
                makeSubsGridView()
            }
            .onAppear { subStore.dispatch(action: .fetchSubs) }
            .alert(item: $subStore.error) { error in
                Alert(title: Text(error.title),
                      message: Text(error.message),
                      dismissButton: .default(Text(error.dimissActionTitle)))
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                Button(action: { isShowingAddSubView.toggle() },
                       label: { Image(systemName: "plus") })
            }
            .sheet(isPresented: $isShowingAddSubView) {
                AddSubView(isPresented: $isShowingAddSubView)
                    .environmentObject(subStore)
            }
        }
    }
    
    // MARK: - Make views methods
    
    private func makeTotalAmountView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                subStore.totalAmount.map {
                    Text($0)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                Text("Amount of your subscriptions each month.")
                    .font(.caption)
                    .italic()
                    .foregroundColor(Color.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func makeTransactionsView() -> some View {
        HStack {
            subStore.totalAmountDebit.map {
                makeTransactionView(value: $0, transaction: Sub.Transaction.debit)
            }
            Spacer()
            subStore.totalAmountCredit.map {
                makeTransactionView(value: $0, transaction: Sub.Transaction.credit)
            }
            Spacer()
            subStore.totalAmountSaving.map {
                makeTransactionView(value: $0, transaction: Sub.Transaction.saving)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func makeTransactionView(value: String, transaction: Sub.Transaction) -> some View {
        VStack(alignment: .leading) {
            Text(value)
                .font(.title2)
                .bold()
                .gradientForeground(colors: transaction.gradientColors)

            Text(transaction.localized)
                .font(.subheadline)
                .italic()
                .foregroundColor(.gray)
        }
    }
    
    private func makeSubsGridView() -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(subStore.subs) { sub in
                NavigationLink(destination: SubDetailsView(sub: sub)) {
                    SubComponent(sub: sub)
                        .contextMenu(menuItems: {
                            Button(action: {
                                subStore.dispatch(action: .delete(sub: sub))
                            }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                        })
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
}

#if DEBUG

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SubView()
                .preferredColorScheme(.dark)
            
            SubView()
        }
        .environmentObject(subStorePreview)
    }
}

#endif
