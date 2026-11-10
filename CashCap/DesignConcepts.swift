//
//  DesignConcepts.swift
//  CashCap
//
//  Scratch file: three visual design mockups with fake data.
//  Safe to delete — nothing in the real app depends on it.
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

// MARK: - Concept 2: Lavender Calm (soft, centered, friendly)

struct DesignLavenderCalm: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xE4DAFF), Color(hex: 0xF7F4FF)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 22) {
                Text("CashCap")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: 0x4C1D95))
                VStack(spacing: 4) {
                    Text("Total Balance")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(Color(hex: 0x6D28D9))
                    Text("€12.75")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x4C1D95))
                    HStack(spacing: 10) {
                        Text("↙ €40.00 in")
                            .foregroundStyle(Color(hex: 0x047857))
                        Text("↗ €27.25 out")
                            .foregroundStyle(Color(hex: 0xBE123C))
                    }
                    .font(.subheadline.weight(.semibold))
                    .padding(.top, 6)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 28))
                VStack(spacing: 12) {
                    ForEach(mockRows) { row in
                        HStack(spacing: 12) {
                            Circle()
                                .fill((row.isIncome ? Color(hex: 0x047857) : Color(hex: 0xBE123C)).opacity(0.15))
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Image(systemName: row.isIncome ? "arrow.down.left" : "arrow.up.right")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(row.isIncome ? Color(hex: 0x047857) : Color(hex: 0xBE123C))
                                )
                            Text(row.name)
                                .foregroundStyle(Color(hex: 0x2E1065))
                            Spacer()
                            Text(row.amount)
                                .foregroundStyle(row.isIncome ? Color(hex: 0x047857) : Color(hex: 0x2E1065))
                        }
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .padding(14)
                        .background(.white, in: RoundedRectangle(cornerRadius: 20))
                    }
                }
                Button {} label: {
                    Label("Add transaction", systemImage: "plus")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x6D28D9))
                Spacer()
            }
            .padding(20)
        }
    }
}

// MARK: - Concept 3: Ocean Glass (banking blue, orange expenses)

struct DesignOceanGlass: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xBAE6FD), Color(hex: 0xF0F9FF)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Text("CashCap")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundStyle(Color(hex: 0x1E3A8A))
                    Spacer()
                    Image(systemName: "plus")
                        .font(.headline)
                        .padding(12)
                        .glassEffect(.regular.tint(Color(hex: 0x1E3A8A).opacity(0.1)))
                }
                VStack(alignment: .leading, spacing: 14) {
                    Text("Total Balance")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    Text("€12.75")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    HStack(spacing: 10) {
                        Label("€40.00", systemImage: "arrow.down.left")
                            .foregroundStyle(Color(hex: 0x86EFAC))
                        Label("€27.25", systemImage: "arrow.up.right")
                            .foregroundStyle(Color(hex: 0xFDBA74))
                    }
                    .font(.subheadline.weight(.semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(LinearGradient(colors: [Color(hex: 0x1E3A8A), Color(hex: 0x0E7490)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing),
                            in: RoundedRectangle(cornerRadius: 24))
                VStack(spacing: 0) {
                    ForEach(mockRows) { row in
                        HStack(spacing: 12) {
                            Image(systemName: row.isIncome ? "arrow.down.left" : "arrow.up.right")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(row.isIncome ? Color(hex: 0x047857) : Color(hex: 0xC2410C))
                                .frame(width: 36, height: 36)
                                .background((row.isIncome ? Color(hex: 0x047857) : Color(hex: 0xC2410C)).opacity(0.12),
                                            in: RoundedRectangle(cornerRadius: 10))
                            Text(row.name)
                                .foregroundStyle(Color(hex: 0x0C4A6E))
                            Spacer()
                            Text(row.amount)
                                .foregroundStyle(row.isIncome ? Color(hex: 0x047857) : Color(hex: 0x0C4A6E))
                        }
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .padding(.vertical, 12)
                        if row.id != mockRows.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 20))
                Spacer()
            }
            .padding(20)
        }
    }
}

#Preview("Mono Luxe") {
    DesignMonoLuxe()
}

#Preview("Lavender Calm") {
    DesignLavenderCalm()
}

#Preview("Ocean Glass") {
    DesignOceanGlass()
}
