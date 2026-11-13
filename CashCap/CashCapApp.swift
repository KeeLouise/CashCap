import SwiftUI

@main
struct CashCapApp: App {
    @State private var store = TransactionStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
