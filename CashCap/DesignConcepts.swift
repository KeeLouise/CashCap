//
//  DesignConcepts.swift
//  CashCap
//
//  Reference mockup of the chosen Mono Luxe design, with fake data.
//

import SwiftUI

private extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}

private struct MockRow: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    let isIncome: Bool
}

private let mockRows = [
    MockRow(name: "Coffee", amount: "−€3.50", isIncome: false),
    MockRow(name: "Babysitting", amount: "+€40.00", isIncome: true),
    MockRow(name: "Groceries", amount: "−€23.75", isIncome: false),
    MockRow(name: "Cinema", amount: "−€11.00", isIncome: false)
]

// MARK: - Concept 1: Mono Luxe (dark premium, lime accent)

struct DesignMonoLuxe: View {
    var body: some View {
        ZStack {
            Color(hex: 0x111827).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 22) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL BALANCE")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(hex: 0x9CA3AF))
                        Text("€12.75")
                            .font(.system(size: 54, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color(hex: 0x111827))
                        .frame(width: 48, height: 48)
                        .background(Color(hex: 0xA3E635), in: Circle())
                }
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.left")
                        Text("€40.00")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(hex: 0xA3E635))
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color(hex: 0x1F2937), in: Capsule())

                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right")
                        Text("€27.25")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(hex: 0xFCA5A5))
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color(hex: 0x1F2937), in: Capsule())
                }
                Text("Recent")
                    .font(.headline)
                    .foregroundStyle(.white)
                VStack(spacing: 10) {
                    ForEach(mockRows) { row in
                        HStack {
                            Text(row.name).foregroundStyle(.white)
                            Spacer()
                            Text(row.amount)
                                .foregroundStyle(row.isIncome ? Color(hex: 0xA3E635) : Color(hex: 0xFCA5A5))
                        }
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .padding(16)
                        .background(Color(hex: 0x1F2937), in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview("Mono Luxe") {
    DesignMonoLuxe()
}
