import SwiftUI

enum DSChipStyle {
    case filled
    case outlined
    case glass
}

struct DSChip: View {
    
    let title: String
    var style: DSChipStyle       = .filled
    var icon: String?            = nil
    var trailingIcon: String?    = nil
    var isSelected: Bool         = false
    var isDisabled: Bool         = false
    var tintColor: Color         = DSColor.accent
    var onTap: (() -> Void)?     = nil
    var onRemove: (() -> Void)?  = nil
    
    var body: some View {
        Button { onTap?() } label: {
            HStack(spacing: DSSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                }
                
                Text(title)
                    .font(DSFont.footnote)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 12, weight: .medium))
                }
                
                if onRemove != nil {
                    Button { onRemove?() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(foregroundColor.opacity(0.7))
                    }
                }
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.xs + 2)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(Capsule()
                .strokeBorder(borderColor, lineWidth: style == .outlined ? 1.5 : 0))
            .scaleEffect(isSelected ? 1.03 : 1.0)
            .opacity(isDisabled ? 0.4 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .disabled(isDisabled)
        .if(style == .glass) { view in
            view.glassEffect(in: Capsule())
        }
    }
    
    private var backgroundColor: Color {
        switch style {
            case .filled:
                return isSelected ? tintColor : tintColor.opacity(0.12)
            case .outlined:
                return isSelected ? tintColor.opacity(0.12) : .clear
            case .glass:
                return .clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
            case .filled:
                return isSelected ? DSColor.Text.onAccent : tintColor
            case .outlined:
                return tintColor
            case .glass:
                return isSelected ? tintColor : DSColor.Text.primary
        }
    }
    
    private var borderColor: Color {
        switch style {
            case .outlined:
                return isSelected ? tintColor : tintColor.opacity(0.3)
            default:
                return .clear
        }
    }
}

    // MARK: - Chip Group
struct DSChipGroup: View {
    
    let chips: [String]
    @Binding var selected: Set<String>
    var style: DSChipStyle       = .filled
    var tintColor: Color         = DSColor.accent
    var multiSelect: Bool        = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSSpacing.sm) {
                ForEach(chips, id: \.self) { chip in
                    DSChip(title: chip,
                           style: style,
                           isSelected: selected.contains(chip),
                           tintColor: tintColor, onRemove:  {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if multiSelect {
                                if selected.contains(chip) {
                                    selected.remove(chip)
                                } else {
                                    selected.insert(chip)
                                }
                            } else {
                                selected = [chip]
                            }
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

#Preview("Styles") {
    @Previewable @State var selected1: Set<String> = ["Premier League"]
    @Previewable @State var selected2: Set<String> = ["Forward", "Midfielder"]
    
    VStack(alignment: .leading, spacing: DSSpacing.xl) {
        
        DSChipGroup(chips: ["Premier League", "La Liga", "Serie A", "Bundesliga", "Ligue 1"],
                    selected: $selected1,
                    style: .filled,
                    tintColor: DSColor.accent)
        
        DSChipGroup(chips: ["Forward", "Midfielder", "Defender", "Goalkeeper"],
                    selected: $selected2,
                    style: .outlined,
                    tintColor: DSColor.secondary,
                    multiSelect: true)
        
        HStack(spacing: DSSpacing.sm) {
            DSChip(title: "Real Madrid",
                   style: .filled,
                   icon: "shield.fill",
                   isSelected: true,
                   tintColor: DSColor.accent)
            DSChip(title: "Remove me",
                   style: .outlined,
                   tintColor: DSColor.Semantic.error,
                   onRemove: {})
            DSChip(title: "Disabled",
                   style: .filled,
                   isDisabled: true,
                   tintColor: DSColor.Text.tertiary)
        }
    }
    .padding(DSSpacing.lg)
}

#Preview("Glass") {
    ZStack {
        LinearGradient(colors: [DSColor.accent, DSColor.secondary],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
        
        VStack(spacing: DSSpacing.lg) {
            HStack(spacing: DSSpacing.sm) {
                DSChip(title: "All", style: .glass, isSelected: true)
                DSChip(title: "Live", style: .glass, icon: "dot.radiowaves.left.and.right")
                DSChip(title: "Upcoming", style: .glass)
                DSChip(title: "Finished", style: .glass)
            }
        }
        .padding(DSSpacing.lg)
    }
}
