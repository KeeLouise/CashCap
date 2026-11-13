import Foundation
import Observation

/// Owns the app's transactions and is the only place they are changed.
/// Views read from it and call its methods, so the rules stay in one place.
@Observable
class TransactionStore {
    var transactions: [Transaction] = [] {
        didSet {
            save()
        }
    }
    init() {
        load()
    }
    
    var selectedMonth = Date.now
    
    var monthTransactions: [Transaction] {
        transactions
            .filter { transaction in
                Calendar.current.isDate(transaction.date, equalTo: selectedMonth, toGranularity: .month)
            }
            .sorted { first, second in
                first.date > second.date
            }
    }
    
    func changeMonth(by months: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: months, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    var newTransactionDate: Date {
        let calendar = Calendar.current
        if calendar.isDate(selectedMonth, equalTo: .now, toGranularity: .month) {
            return .now
        }
        return calendar.dateInterval(of: .month, for: selectedMonth)?.start ?? selectedMonth
    }
    
    /// Sum of all transactions of one kind.
    func total(for kind: TransactionKind) -> Decimal {
        monthTransactions
            .filter { transaction in
                transaction.kind == kind
            }
            .map { transaction in
                transaction.amount
            }
            .reduce(0, +)
    }

    var totalIncome: Decimal { total(for: .income) }
    var totalExpenses: Decimal { total(for: .expense) }
    var totalSavings: Decimal { total(for: .savings) }

    /// Money left after expenses and money set aside.
    var balance: Decimal {
        totalIncome - totalExpenses - totalSavings
    }

    func delete(at offsets: IndexSet) {
        let ids = offsets.map { monthTransactions[$0].id}
        transactions.removeAll() { transaction in
            ids.contains(transaction.id)
        }
    }
    
    //STORAGE
    
    ///Where the transactions are stored, inside the app's private documents folder
    private var saveURL: URL {
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
}
