import SwiftUI

// MARK: - Configuration enums
enum DSCardStyle {
    case elevated
    case filled
    case outlined
    case glass
}

// MARK: - Main Component
struct DSCard<Content: View>: View {
    
    var style: DSCardStyle        = .elevated
    var cornerRadius: CGFloat     = DSRadius.lg
    var padding: CGFloat          = DSSpacing.lg
    var isSelected: Bool          = false
    var isExpandable: Bool        = false
    var onTap: (() -> Void)?      = nil
    @ViewBuilder let content: () -> Content
    
    @State private var isExpanded: Bool  = false
    @State private var isPressed: Bool   = false
    
    var body: some View {
        cardContent
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .onTapGesture {
                if isExpandable {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }
                onTap?()
            }
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false })
    }
    
    // MARK: - Card content
    @ViewBuilder
    private var cardContent: some View {
        switch style {
            case .elevated:
                elevatedCard
            case .filled:
                filledCard
            case .outlined:
                outlinedCard
            case .glass:
                glassCard
        }
    }
    
    // MARK: - Elevated
    private var elevatedCard: some View {
        contentView
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(isSelected ? 0.18 : 0.08),
                    radius: isSelected ? 16 : 8,
                    x: 0,
                    y: isSelected ? 6 : 3)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(DSColor.accent.opacity(isSelected ? 1 : 0), lineWidth: 2))
    }
    
    // MARK: - Filled
    private var filledCard: some View {
        contentView
            .background(DSColor.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(DSColor.accent.opacity(isSelected ? 1 : 0), lineWidth: 2))
    }
    
    // MARK: - Outlined
    private var outlinedCard: some View {
        contentView
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(isSelected ? DSColor.accent : Color(uiColor: .separator), lineWidth: isSelected ? 2 : 1))
    }
    
    // MARK: - Glass (iOS 26)
    private var glassCard: some View {
        contentView
            .glassEffect(in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(DSColor.accent.opacity(isSelected ? 0.6 : 0), lineWidth: 1.5))
    }
    
    // MARK: - Content wrapper
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
                .padding(padding)
            
            if isExpandable {
                Divider()
                    .padding(.horizontal, padding)
                
                HStack {
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(DSColor.Text.secondary)
                }
                .padding(.horizontal, padding)
                .padding(.vertical, DSSpacing.sm)
            }
        }
    }
}
