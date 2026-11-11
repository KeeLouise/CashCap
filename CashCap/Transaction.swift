//
//  Transaction.swift
//  CashCap
//
//  Created by Kiera Reidy on 09/11/2026.
//

import Foundation

enum TransactionKind {
    case income
    case expense
    case savings
}

struct Transaction: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var kind: TransactionKind
    var date: Date
}
