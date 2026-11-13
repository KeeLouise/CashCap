import SwiftUI

/// Header for choosing which month the screen shows
struct MonthSwitcher: View {
    @Environment(TransactionStore.self) private var store
    
    var body: some View {
        HStack {
            Button {
                store.changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Previous month")
            
            Spacer()
            
            Text(store.selectedMonth, format: .dateTime.month(.wide).year())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            Spacer ()
            
            Button {
                            store.changeMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                                .frame(width: 44, height: 44)
                        }
                        .accessibilityLabel("Next month")
                    }
                    .foregroundStyle(Color.luxeLime)
                    .padding(.horizontal)
                }
            }
