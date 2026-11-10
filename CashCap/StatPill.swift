//
//  StatPill.swift
//  CashCap
//
//  The small rounded totals under the balance (income, expenses, savings).
//

import SwiftUI

struct StatPill: View {
    let title: String
    let kind: TransactionKind
    let amount: Double

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: kind.icon)
            Text(amount, format: .appCurrency)
        }
        //never split an amount across lines; the parent stacks pills instead when space runs out
        .fixedSize()
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(kind.color)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.luxeCard, in: Capsule())
        //VoiceOver reads one clear phrase, e.g. "Expenses €27.25", not icon + number separately
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) \(amount.formatted(.appCurrency))")
    }
}
