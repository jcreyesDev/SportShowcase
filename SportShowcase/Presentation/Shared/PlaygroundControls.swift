import SwiftUI

    // MARK: - Compact control helpers
struct CompactControlRow: View {
    let title: String
    let options: [String]
    @Binding var selected: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(DSColor.Text.secondary)
            Spacer()
            HStack(spacing: 6) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    Circle()
                        .fill(selected == index ? DSColor.accent : DSColor.Text.tertiary.opacity(0.3))
                        .frame(width: 7, height: 7)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.2)) {
                                selected = index
                            }
                        }
                    if index < options.count - 1 {
                        Text(option)
                            .font(.system(size: 10))
                            .foregroundStyle(selected == index
                                             ? DSColor.accent
                                             : DSColor.Text.tertiary)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2)) {
                                    selected = index
                                }
                            }
                    } else {
                        Text(option)
                            .font(.system(size: 10))
                            .foregroundStyle(selected == index
                                             ? DSColor.accent
                                             : DSColor.Text.tertiary)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2)) {
                                    selected = index
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .frame(maxWidth: .infinity)
        
        DSDivider()
            .padding(.horizontal, DSSpacing.md)
    }
}

struct CompactToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(DSColor.Text.secondary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(DSColor.accent)
                .scaleEffect(0.75)
                .frame(width: 44)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.xs)
        .frame(maxWidth: .infinity)
        
        DSDivider()
            .padding(.horizontal, DSSpacing.md)
    }
}

struct CompactValueRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(DSColor.Text.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DSColor.Text.primary)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .frame(maxWidth: .infinity)
        
        DSDivider()
            .padding(.horizontal, DSSpacing.md)
    }
}
