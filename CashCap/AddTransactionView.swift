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
    var initialDate: Date = .now
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
                    save()
                }
                if let errorMessage{
                    Text (errorMessage)
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
                amountText = "\(editing.amount)"
                kind = editing.kind
                date = editing.date
            } else {
                date = initialDate
            }
        }
    }
    
    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Enter a name for this transaction."
            return
        }

        guard let amount = parseAmount(amountText), amount > 0 else {
            errorMessage = "“\(amountText)” isn’t a valid amount. Use a number above zero, like 12.50."
            return
        }
        
        if let editing, let index = transactions.firstIndex(where: {transaction in transaction.id == editing.id})
        {
            transactions[index].name = trimmedName
            transactions[index].amount = amount
            transactions[index].kind = kind
            transactions[index].date = date
        } else {
            transactions.append(Transaction(name: trimmedName, amount: amount, kind: kind, date: date))
        }
        dismiss()
    }
    
    /// Accepts digits with an optional "." or "," and at most two decimals.
    /// Anything else is rejected rather than partly read.
    private func parseAmount(_ text: String) -> Decimal? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard trimmed.wholeMatch(of: /[0-9]+([.,][0-9]{1,2})?/) != nil else { return nil }
        return Decimal(string: trimmed.replacingOccurrences(of: ",", with: "."))
    }
}

