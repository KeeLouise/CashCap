//
//  ContentView.swift
//  CashCap
//
//  Created by Kiera Reidy on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    //array of transactions
    @State private var transactions = [
        Transaction(name: "Coffee", amount: 3.50, kind: .expense),
        Transaction(name: "Babysitting", amount: 40.00, kind: .income),
        Transaction(name: "Groceries", amount: 23.75, kind: .expense)
    ]
    
    @State private var showingAddSheet = false
    
    //scales the big balance number with the user's Dynamic Type setting (WCAG 1.4.4 resize text)
    @ScaledMetric(relativeTo: .largeTitle) private var balanceFontSize = 56.0
    
    var incomeTransactions: [Transaction] {
        transactions.filter { transaction in
            transaction.kind == .income}
    }
    
    var expenseTransactions: [Transaction] {
        transactions.filter { transaction in
            transaction.kind == .expense}
    }
    
    var totalIncome: Double {
        incomeTransactions.map { transaction in
            transaction.amount
        }.reduce(0, +)
    }
    
    var totalExpenses: Double {
        expenseTransactions.map { transaction in transaction.amount
        }.reduce(0, +)
    }
    
    var balance: Double {
        totalIncome - totalExpenses
    }
    
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
                        Text(balance, format: .currency(code: "EUR"))
                            .font(.system(size: balanceFontSize, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)

                        //income / expense stats as Liquid Glass pills
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.down.left")
                                Text(totalIncome, format: .currency(code: "EUR"))
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.luxeLime)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.luxeCard, in: Capsule())
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Income \(totalIncome.formatted(.currency(code: "EUR")))")

                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.right")
                                Text(totalExpenses, format: .currency(code: "EUR"))
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.luxeRed)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.luxeCard, in: Capsule())
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Expenses \(totalExpenses.formatted(.currency(code: "EUR")))")
                        }
                        .padding(.top, 8)
                    }
                    .padding(.top, 12)

                    //one row per transaction
                    List {
                        Section("Recent Activity") {
                            ForEach(transactions) { transaction in
                                HStack(spacing: 14) {
                                    Image(systemName: transaction.kind == .income
                                          ? "arrow.down.left" : "arrow.up.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(transaction.kind == .income ? Color.luxeLime : Color.luxeRed)
                                        .frame(width: 38, height: 38)
                                        .background((transaction.kind == .income ? Color.luxeLime : Color.luxeRed).opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(transaction.name)
                                            .font(.body.weight(.medium))
                                        Text(transaction.kind == .income ? "Income" : "Expense")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(transaction.kind == .income ? "+" : "−")\(transaction.amount, format: .currency(code: "EUR"))")
                                        .foregroundStyle(transaction.kind == .income ? Color.luxeLime : Color.luxeRed)
                                }
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                //reads each row to VoiceOver as one element, e.g. "Coffee, Expense, −€3.50"
                                .accessibilityElement(children: .combine)
                                .listRowBackground(Color.luxeCard)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("CashCap")
            .toolbar {
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
            .sheet(isPresented: $showingAddSheet) {
                AddTransactionView(transactions: $transactions)
            }
        }
        //Mono Luxe commits to dark styling in both system modes
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
