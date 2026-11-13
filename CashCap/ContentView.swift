//
//  ContentView.swift
//  CashCap
//
//  Created by Kiera Reidy on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var store = TransactionStore()
    
    @State private var showingAddSheet = false
    
    @State private var editingTransaction: Transaction?
    
    //scales the big balance number with the user's Dynamic Type setting (WCAG 1.4.4 resize text)
    @ScaledMetric(relativeTo: .largeTitle) private var balanceFontSize = 56.0
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                //Mono Luxe: committed dark canvas
                Color.luxeBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    //balance header: airy, typography-led
                    VStack(spacing: 6) {
                        Text("Total Balance")
                            .font(.footnote.weight(.semibold))
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                        Text(store.balance, format: .appCurrency)
                            .font(.system(size: balanceFontSize, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        
                        //income / expense / savings totals
                        //side by side when they fit, stacked when text size makes them too wide
                        ViewThatFits {
                            HStack(spacing: 12) {
                                StatPill(title: "Income", kind: .income, amount: store.totalIncome)
                                StatPill(title: "Expenses", kind: .expense, amount: store.totalExpenses)
                                StatPill(title: "Savings", kind: .savings, amount: store.totalSavings)
                            }
                            VStack(spacing: 8) {
                                StatPill(title: "Income", kind: .income, amount: store.totalIncome)
                                StatPill(title: "Expenses", kind: .expense, amount: store.totalExpenses)
                                StatPill(title: "Savings", kind: .savings, amount: store.totalSavings)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.top, 12)
                    
                    //one row per transaction
                    if store.transactions.isEmpty {
                        ContentUnavailableView {
                            Label("No transactions yet", systemImage: "tray")
                        } description: {
                            Text("Add your first income, expense or saving.")
                        } actions: {
                            Button("Add transaction") {
                                showingAddSheet = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.luxeLime)
                            .foregroundStyle(Color.luxeBackground)
                        }
                    } else {
                        List {
                            Section("Recent Activity") {
                                ForEach(store.transactions) { transaction in
                                    Button {
                                        editingTransaction = transaction
                                    } label: {
                                        TransactionRow(transaction: transaction)
                                    }
                                    .buttonStyle(.plain)
                                    .listRowBackground(Color.luxeCard)
                                }
                                .onDelete(perform: store.delete)
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .tint(.luxeLime)
                            .disabled(store.transactions.isEmpty)
                    }
                    ToolbarItem(placement:  .topBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(Color.luxeBackground)
                                .frame(width: 36, height: 36)
                                .background(Color.luxeLime, in: Circle())
                        }
                        .accessibilityLabel("Add transaction")
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    AddTransactionView(transactions: $store.transactions)
                }
                .sheet(item: $editingTransaction) { transaction in
                    AddTransactionView(transactions: $store.transactions, editing: transaction)
                }
            
            //Mono Luxe commits to dark styling in both system modes
            //(AddTransactionView sets this too: sheets don't inherit it)
            .preferredColorScheme(.dark)
            .onAppear {
                store.load()
            }
            .onChange(of: store.transactions) {
                store.save()
            }
        }
    }
}

#Preview {
    ContentView()
}
