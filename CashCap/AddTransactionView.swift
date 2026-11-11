//
//  AddTransactionView.swift
//  CashCap
//
//  Created by Kiera Reidy on 10/11/2026.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var transactions: [Transaction]
    var editing: Transaction? = nil
    @State private var name = ""
    @State private var amountText = ""
    @State private var kind: TransactionKind = .expense
    @State private var date = Date.now
    //optional String: nil means "no error right now" (WCAG 3.3.1: errors must be visible, not just in the console)
    @State private var errorMessage: String?
    
    var body: some View {
        Form {
            //section headers act as visible, persistent labels (placeholders alone vanish while typing)
            Section("Name") {
                TextField("e.g. Groceries", text: $name)
            }
            Section("Amount") {
                TextField("0.00", text: $amountText)
                    .keyboardType(.decimalPad)
            }
            Section("Kind") {
                Picker("Kind", selection: $kind) {
                    Text("Expense").tag(TransactionKind.expense)
                    Text("Income").tag(TransactionKind.income)
                    Text("Savings").tag(TransactionKind.savings)
                }.pickerStyle(.segmented)
            }
            Section("Date") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            Section {
                Button("Save") {
                    if let amount = Double(amountText) {
                        if let editing, let index = transactions.firstIndex(where: { transaction in
                            transaction.id == editing.id
                        }) {
                            transactions[index].name = name
                            transactions[index].amount = amount
                            transactions[index].kind = kind
                            transactions[index].date = date
                        } else {
                            transactions.append(Transaction(name: name, amount: amount, kind: kind, date: date))
                        }
                        dismiss()
                    } else {
                        errorMessage = "“\(amountText)” isn’t a valid amount. Enter a number like 12.50."
                    }
                }
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(Color.luxeRed)
                }
            }
        }
        .tint(.luxeLime)
        //sheets don't inherit the presenting view's color scheme, so commit to dark here too
        .preferredColorScheme(.dark)
        .onAppear{
            if let editing {
                name = editing.name
                amountText = String(editing.amount)
                kind = editing.kind
                date = editing.date
            }
        }
    }
}

