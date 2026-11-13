import Foundation
import Observation

/// Owns the app's transactions and is the only place they are changed.
/// Views read from it and call its methods, so the rules stay in one place.
@Observable
class TransactionStore {
    var transactions: [Transaction] = []
    
    /// Sum of all transactions of one kind.
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

    /// Money left after expenses and money set aside.
    var balance: Double {
        totalIncome - totalExpenses - totalSavings
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            transactions.remove(at: index)
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
