//
//  ContentView.swift
//  CashCap
//
//  Created by Kiera Reidy on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    //array of transactions
    @State private var transactions: [Transaction] = []

    @State private var showingAddSheet = false
    
    @State private var editingTransaction: Transaction?

    //scales the big balance number with the user's Dynamic Type setting (WCAG 1.4.4 resize text)
    @ScaledMetric(relativeTo: .largeTitle) private var balanceFontSize = 56.0

    //total amount of every transaction of one kind
    func total(for kind: TransactionKind) -> Double {
        transactions
            .filter { transaction in
                transaction.kind == kind
            }
            .map { transaction in
                transaction.amount
            }
            .reduce(0, +)
    }

    var totalIncome: Double { total(for: .income) }
    var totalExpenses: Double { total(for: .expense) }
    var totalSavings: Double { total(for: .savings) }

    //savings leave your spendable money but aren't "spent"
    var balance: Double {
        totalIncome - totalExpenses - totalSavings
    }
    
    func delete(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
    }
    
    var saveURL: URL {
        URL.documentsDirectory.appending(path: "transactions.json")
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(transactions)
            try data.write(to: saveURL, options: .atomic)
        } catch {
            print("Could not save transactions: \(error)")
        }
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            transactions = try JSONDecoder().decode([Transaction].self, from: data)
        } catch {
            print("Nothing to load: \(error)")
        }
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
                        Text(balance, format: .appCurrency)
                            .font(.system(size: balanceFontSize, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)

                        //income / expense / savings totals
                        //side by side when they fit, stacked when text size makes them too wide
                        ViewThatFits {
                            HStack(spacing: 12) {
                                StatPill(title: "Income", kind: .income, amount: totalIncome)
                                StatPill(title: "Expenses", kind: .expense, amount: totalExpenses)
                                StatPill(title: "Savings", kind: .savings, amount: totalSavings)
                            }
                            VStack(spacing: 8) {
                                StatPill(title: "Income", kind: .income, amount: totalIncome)
                                StatPill(title: "Expenses", kind: .expense, amount: totalExpenses)
                                StatPill(title: "Savings", kind: .savings, amount: totalSavings)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.top, 12)

                    //one row per transaction
                    List {
                        Section("Recent Activity") {
                            ForEach(transactions) { transaction in
                                Button {
                                    editingTransaction = transaction
                                } label: {
                                    TransactionRow(transaction: transaction)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(Color.luxeCard)
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("CashCap")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .tint(.luxeLime)
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
                AddTransactionView(transactions: $transactions)
            }
            .sheet(item: $editingTransaction) { transaction in
                AddTransactionView(transactions: $transactions, editing: transaction)
            }
        }
        //Mono Luxe commits to dark styling in both system modes
        //(AddTransactionView sets this too: sheets don't inherit it)
        .preferredColorScheme(.dark)
        .onAppear {
            load()
        }
        .onChange(of: transactions) {
            save()
        }
    }
}

#Preview {
    ContentView()
}
