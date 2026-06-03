import SwiftUI

enum DSBadgeStyle {
    case accent
    case secondary
    case success
    case warning
    case error
    case neutral
}

struct DSBadge: View {
    
    let title: String
    var style: DSBadgeStyle  = .accent
    var icon: String?        = nil
    var size: DSButtonSize   = .small
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
            }
            Text(title)
                .font(DSFont.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
    
    private var backgroundColor: Color {
        switch style {
            case .accent:    return DSColor.accent.opacity(0.12)
            case .secondary: return DSColor.secondary.opacity(0.12)
            case .success:   return DSColor.Semantic.success.opacity(0.12)
            case .warning:   return DSColor.Semantic.warning.opacity(0.12)
            case .error:     return DSColor.Semantic.error.opacity(0.12)
            case .neutral:   return DSColor.Text.tertiary.opacity(0.12)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
            case .accent:    return DSColor.accent
            case .secondary: return DSColor.secondary
            case .success:   return DSColor.Semantic.success
            case .warning:   return DSColor.Semantic.warning
            case .error:     return DSColor.Semantic.error
            case .neutral:   return DSColor.Text.secondary
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.lg) {
        HStack(spacing: DSSpacing.sm) {
            DSBadge(title: "Forward", style: .accent)
            DSBadge(title: "Midfielder", style: .secondary)
            DSBadge(title: "Defender", style: .neutral)
        }
        HStack(spacing: DSSpacing.sm) {
            DSBadge(title: "Active", style: .success, icon: "checkmark.circle.fill")
            DSBadge(title: "Injured", style: .error, icon: "exclamationmark.circle.fill")
            DSBadge(title: "Suspended", style: .warning, icon: "minus.circle.fill")
        }
    }
    .padding(DSSpacing.lg)
}
