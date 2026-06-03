import SwiftUI

// MARK: - Configuration enums
enum DSButtonStyle {
    case filled
    case outlined
    case ghost
    case destructive
}

enum DSButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
            case .small:  return 32
            case .medium: return 44
            case .large:  return 56
        }
    }
    
    var font: Font {
        switch self {
            case .small:  return DSFont.footnote
            case .medium: return DSFont.subheadline
            case .large:  return DSFont.headline
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
            case .small:  return DSSpacing.md
            case .medium: return DSSpacing.lg
            case .large:  return DSSpacing.xl
        }
    }
}

enum DSButtonIconPosition {
    case leading
    case trailing
}

// MARK: - Main Component
struct DSButton: View {
    
    let title: String
    var style: DSButtonStyle     = .filled
    var size: DSButtonSize       = .medium
    var icon: String?            = nil
    var iconPosition: DSButtonIconPosition = .leading
    var isFullWidth: Bool        = false
    var isLoading: Bool          = false
    var isDisabled: Bool         = false
    let action: () -> Void
    
    var body: some View {
        Button(action: { if !isLoading && !isDisabled { action() } }) {
            content
                .frame(height: size.height)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.horizontal, size.horizontalPadding)
                .background(backgroundColor)
                .foregroundStyle(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.lg)
                        .strokeBorder(borderColor, lineWidth: style == .outlined ? 1.5 : 0)
                )
                .opacity(isDisabled ? 0.4 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView()
                .tint(foregroundColor)
                .scaleEffect(size == .small ? 0.7 : 1.0)
        } else {
            HStack(spacing: DSSpacing.sm) {
                if let icon, iconPosition == .leading {
                    Image(systemName: icon)
                        .font(size.font)
                }
                Text(title)
                    .font(size.font)
                    .fontWeight(.medium)
                    .lineLimit(1)
                if let icon, iconPosition == .trailing {
                    Image(systemName: icon)
                        .font(size.font)
                }
            }
        }
    }
    
    // MARK: - Style helpers
    private var backgroundColor: Color {
        switch style {
            case .filled:      return DSColor.accent
            case .outlined:    return .clear
            case .ghost:       return .clear
            case .destructive: return DSColor.Semantic.error
        }
    }
    
    private var foregroundColor: Color {
        switch style {
            case .filled:      return DSColor.Text.onAccent
            case .outlined:    return DSColor.accent
            case .ghost:       return DSColor.accent
            case .destructive: return DSColor.Text.onAccent
        }
    }
    
    private var borderColor: Color {
        switch style {
            case .filled:      return .clear
            case .outlined:    return DSColor.accent
            case .ghost:       return .clear
            case .destructive: return .clear
        }
    }
}

#Preview("Styles") {
    VStack(spacing: DSSpacing.lg) {
        DSButton(title: "Filled Button", style: .filled) {}
        DSButton(title: "Outlined Button", style: .outlined) {}
        DSButton(title: "Ghost Button", style: .ghost) {}
        DSButton(title: "Destructive", style: .destructive) {}
    }
    .padding(DSSpacing.lg)
}

#Preview("Sizes") {
    VStack(spacing: DSSpacing.lg) {
        DSButton(title: "Large Button", size: .large, isFullWidth: true) {}
        DSButton(title: "Medium Button", size: .medium) {}
        DSButton(title: "Small Button", size: .small) {}
    }
    .padding(DSSpacing.lg)
}

#Preview("States") {
    VStack(spacing: DSSpacing.lg) {
        DSButton(title: "Loading", isLoading: true) {}
        DSButton(title: "Disabled", isDisabled: true) {}
        DSButton(title: "With Icon", icon: "star.fill") {}
        DSButton(title: "Trailing Icon", icon: "arrow.right", iconPosition: .trailing) {}
    }
    .padding(DSSpacing.lg)
}
