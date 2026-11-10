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
}

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let kind: TransactionKind
}
