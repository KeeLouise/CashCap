//
//  TransactionRow.swift
//  CashCap
//
//  One row in the Recent Activity list.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var icon: some View {
        Image(systemName: transaction.kind.icon)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(transaction.kind.color)
            .frame(width: 38, height: 38)
            .background(transaction.kind.color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var titles: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(transaction.name)
                .font(.body.weight(.medium))
            Text(transaction.kind.label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    //an amount must never break across lines
    private var amount: some View {
        Text("\(transaction.kind.sign)\(transaction.amount, format: .appCurrency)")
            .foregroundStyle(transaction.kind.color)
            .fixedSize()
    }

    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                //large text: stack the amount under the name so neither is squeezed
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 14) {
                        icon
                        titles
                    }
                    amount
                }
            } else {
                HStack(spacing: 14) {
                    icon
                    titles
                    Spacer()
                    amount
                }
            }
        }
        .font(.system(.body, design: .rounded).weight(.semibold))
        //reads each row to VoiceOver as one element, e.g. "Coffee, Expense, −€3.50"
        .accessibilityElement(children: .combine)
    }
}
