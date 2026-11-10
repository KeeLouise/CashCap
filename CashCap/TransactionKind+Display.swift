//
//  TransactionKind+Display.swift
//  CashCap
//
//  How each kind of transaction looks on screen. Adding a new kind to the
//  enum makes the compiler ask for it in every switch below.
//

import SwiftUI

extension TransactionKind {
    var color: Color {
        switch self {
        case .income: return .luxeLime
        case .expense: return .luxeRed
        case .savings: return .white
        }
    }

    //SF Symbol name
    var icon: String {
        switch self {
        case .income: return "arrow.down.left"
        case .expense: return "arrow.up.right"
        case .savings: return "banknote"
        }
    }

    var label: String {
        switch self {
        case .income: return "Income"
        case .expense: return "Expense"
        case .savings: return "Savings"
        }
    }

    //prefix shown before an amount; savings is money moved, not gained or spent
    var sign: String {
        switch self {
        case .income: return "+"
        case .expense: return "−"
        case .savings: return ""
        }
    }
}
