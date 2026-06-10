import SwiftUI

enum DSListStyle {
    case plain
    case grouped
    case insetGrouped
}

enum DSListItemAccessory {
    case none
    case chevron
    case toggle(Binding<Bool>)
    case badge(String)
    case custom(AnyView)
}

struct DSListItem: Identifiable {
    let id: String
    let title: String
    var subtitle: String?          = nil
    var icon: String?              = nil
    var iconColor: Color           = DSColor.accent
    var accessory: DSListItemAccessory = .none
    var onTap: (() -> Void)?       = nil
}

struct DSList: View {
    
    let items: [DSListItem]
    var style: DSListStyle         = .insetGrouped
    var header: String?            = nil
    var footer: String?            = nil
    var showDividers: Bool         = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header {
                Text(header.uppercased())
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Text.tertiary)
                    .padding(.horizontal, headerPadding)
                    .padding(.bottom, DSSpacing.xs)
            }
            
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    DSListItemRow(item: item)
                    
                    if showDividers && index < items.count - 1 {
                        DSDivider()
                            .padding(.leading, item.icon != nil ? 56 : DSSpacing.lg)
                    }
                }
            }
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: style == .plain ? 0 : DSRadius.lg))
            .overlay(style == .plain ? nil :
                        RoundedRectangle(cornerRadius: DSRadius.lg)
                .strokeBorder(DSColor.Text.tertiary.opacity(0.15), lineWidth: 0.5))
            
            if let footer {
                Text(footer)
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Text.tertiary)
                    .padding(.horizontal, headerPadding)
                    .padding(.top, DSSpacing.xs)
            }
        }
    }
    
    private var headerPadding: CGFloat {
        style == .plain ? DSSpacing.lg : DSSpacing.md
    }
}

// MARK: - List item row
struct DSListItemRow: View {
    
    let item: DSListItem
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: DSSpacing.md) {
            
                // Icon
            if let icon = item.icon {
                ZStack {
                    RoundedRectangle(cornerRadius: DSRadius.sm)
                        .fill(item.iconColor.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundStyle(item.iconColor)
                }
            }
            
                // Title + subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Text.primary)
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Text.tertiary)
                }
            }
            
            Spacer()
            
                // Accessory
            accessoryView
        }
        .padding(.horizontal, DSSpacing.lg)
        .padding(.vertical, DSSpacing.md)
        .background(isPressed ? DSColor.Background.secondary : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            item.onTap?()
        }
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if item.onTap != nil { isPressed = true }
            }
            .onEnded { _ in isPressed = false })
    }
    
    @ViewBuilder
    private var accessoryView: some View {
        switch item.accessory {
            case .none:
                EmptyView()
            case .chevron:
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(DSColor.Text.tertiary)
            case .toggle(let binding):
                Toggle("", isOn: binding)
                    .labelsHidden()
                    .tint(DSColor.accent)
            case .badge(let text):
                DSBadge(title: text, style: .accent)
            case .custom(let view):
                view
        }
    }
}

#Preview {
    @Previewable @State var toggle1 = true
    @Previewable @State var toggle2 = false
    
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSList(items: [
                DSListItem(id: "1",
                           title: "Premier League",
                           subtitle: "England · 20 teams",
                           icon: "trophy",
                           iconColor: DSColor.accent,
                           accessory: .chevron,
                           onTap: {}),
                DSListItem(id: "2",
                           title: "La Liga",
                           subtitle: "Spain · 20 teams",
                           icon: "trophy",
                           iconColor: DSColor.secondary,
                           accessory: .chevron,
                           onTap: {}),
                DSListItem(id: "3",
                           title: "Serie A",
                           subtitle: "Italy · 20 teams",
                           icon: "trophy",
                           iconColor: DSColor.Semantic.success,
                           accessory: .badge("New"),
                           onTap: {})
            ], header: "Leagues", footer: "Showing 3 of 5 leagues")
            
            DSList(items: [
                DSListItem(id: "4",
                           title: "Notifications",
                           icon: "bell",
                           iconColor: DSColor.Semantic.error,
                           accessory: .toggle($toggle1)),
                DSListItem(id: "5",
                           title: "Dark Mode",
                           icon: "moon",
                           iconColor: DSColor.accent,
                           accessory: .toggle($toggle2)),
                DSListItem(id: "6",
                           title: "Language",
                           subtitle: "English",
                           icon: "globe",
                           iconColor: DSColor.secondary,
                           accessory: .chevron,
                           onTap: {})
            ], header: "Settings")
        }
        .padding(DSSpacing.lg)
    }
}
