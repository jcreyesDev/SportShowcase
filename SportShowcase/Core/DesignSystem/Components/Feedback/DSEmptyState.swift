import SwiftUI

enum DSEmptyStateStyle {
    case standard
    case compact
    case fullScreen
}

struct DSEmptyState: View {
    
    let title: String
    var message: String?              = nil
    var icon: String                  = "tray"
    var style: DSEmptyStateStyle      = .standard
    var actionTitle: String?          = nil
    var onAction: (() -> Void)?       = nil
    var iconColor: Color              = DSColor.Text.tertiary
    
    var body: some View {
        switch style {
            case .standard:   standardEmpty
            case .compact:    compactEmpty
            case .fullScreen: fullScreenEmpty
        }
    }
    
    // MARK: - Standard
    private var standardEmpty: some View {
        VStack(spacing: DSSpacing.lg) {
            iconView(size: 56)
            textContent
            actionButton
        }
        .frame(maxWidth: .infinity)
        .padding(DSSpacing.xl)
    }
    
    // MARK: - Compact
    private var compactEmpty: some View {
        HStack(spacing: DSSpacing.md) {
            iconView(size: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSFont.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                if let message {
                    Text(message)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Text.tertiary)
                }
            }
            Spacer()
            actionButton
        }
        .padding(DSSpacing.md)
    }
    
    // MARK: - Full screen
    private var fullScreenEmpty: some View {
        VStack(spacing: DSSpacing.xl) {
            Spacer()
            iconView(size: 80)
                .padding(.bottom, DSSpacing.sm)
            textContent
            if let actionTitle, let onAction {
                DSButton(title: actionTitle,
                         style: .filled,
                         isFullWidth: true,
                         action: onAction)
                .padding(.horizontal, DSSpacing.xl)
                .padding(.top, DSSpacing.sm)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Shared subviews
    private func iconView(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(iconColor.opacity(0.08))
                .frame(width: size * 1.6, height: size * 1.6)
            Image(systemName: icon)
                .font(.system(size: size * 0.55, weight: .light))
                .foregroundStyle(iconColor.opacity(0.6))
        }
    }
    
    private var textContent: some View {
        VStack(spacing: DSSpacing.xs) {
            Text(title)
                .font(DSFont.headline)
                .fontWeight(.medium)
                .foregroundStyle(DSColor.Text.primary)
                .multilineTextAlignment(.center)
            if let message {
                Text(message)
                    .font(DSFont.subheadline)
                    .foregroundStyle(DSColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @ViewBuilder
    private var actionButton: some View {
        if let actionTitle, let onAction {
            DSButton(title: actionTitle,
                     style: .outlined,
                     action: onAction)
        }
    }
}

#Preview("Standard") {
    VStack(spacing: DSSpacing.xl) {
        DSEmptyState(title: "No matches found",
                     message: "Try adjusting your search or filters",
                     icon: "sportscourt",
                     style: .standard,
                     actionTitle: "Clear filters",
                     onAction: {},
                     iconColor: DSColor.accent)
        
        DSEmptyState(title: "No favorites yet",
                     message: "Add teams and players to your favorites",
                     icon: "heart",
                     style: .compact,
                     actionTitle: "Explore",
                     onAction: {},
                     iconColor: DSColor.Semantic.error)
    }
    .padding(DSSpacing.lg)
}

#Preview("Full Screen") {
    DSEmptyState(title: "No players available",
                 message: "There are no players registered for this team yet. Check back later.",
                 icon: "person.2",
                 style: .fullScreen,
                 actionTitle: "Go back",
                 onAction: {},
                 iconColor: DSColor.secondary)
}
