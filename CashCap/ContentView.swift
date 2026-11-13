//
//  ContentView.swift
//  CashCap
//
//  Created by Kiera Reidy on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(TransactionStore.self) private var store

    @State private var showingAddSheet = false

    @State private var editingTransaction: Transaction?

    //scales the big balance number with the user's Dynamic Type setting (WCAG 1.4.4 resize text)
    @ScaledMetric(relativeTo: .largeTitle) private var balanceFontSize = 56.0

    //balance and totals for the selected month; scrolls with the content so nothing is
    //cut off at large text sizes
    private var balanceHeader: some View {
        VStack(spacing: 6) {
            Text("Balance this month")
                .font(.footnote.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            Text(store.balance, format: .appCurrency)
                .font(.system(size: balanceFontSize, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                //an amount must never break across lines: shrink to fit instead
                .lineLimit(1)
                .minimumScaleFactor(0.4)

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
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                //Mono Luxe: committed dark canvas
                Color.luxeBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    MonthSwitcher()
                    if store.monthTransactions.isEmpty {
                        ScrollView {
                            VStack(spacing: 20) {
                                balanceHeader
                                ContentUnavailableView {
                                    Label("Nothing in this month", systemImage: "tray")
                                } description: {
                                    Text("Add an income, expense or saving.")
                                } actions: {
                                    Button("Add transaction") {
                                        showingAddSheet = true
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.luxeLime)
                                    .foregroundStyle(Color.luxeBackground)
                                }
                            }
                        }
                    } else {
                        List {
                            balanceHeader
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)

                            Section("Recent Activity") {
                                ForEach(store.monthTransactions) { transaction in
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
                        .disabled(store.monthTransactions.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
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
                AddTransactionView(transactions: Bindable(store).transactions,
                                   initialDate: store.newTransactionDate)
            }
            .sheet(item: $editingTransaction) { transaction in
                AddTransactionView(transactions: Bindable(store).transactions, editing: transaction)
            }
            //Mono Luxe commits to dark styling in both system modes
            //(AddTransactionView sets this too: sheets don't inherit it)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
        .environment(TransactionStore())
}

