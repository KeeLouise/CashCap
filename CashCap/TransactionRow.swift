//
//  TransactionRow.swift
//  CashCap
//
//  One row in the Recent Activity list.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: transaction.kind.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(transaction.kind.color)
                .frame(width: 38, height: 38)
                .background(transaction.kind.color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.name)
                    .font(.body.weight(.medium))
                Text(transaction.kind.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(transaction.kind.sign)\(transaction.amount, format: .appCurrency)")
                .foregroundStyle(transaction.kind.color)
        }
        .font(.system(.body, design: .rounded).weight(.semibold))
        //reads each row to VoiceOver as one element, e.g. "Coffee, Expense, −€3.50"
        .accessibilityElement(children: .combine)
    }
}
