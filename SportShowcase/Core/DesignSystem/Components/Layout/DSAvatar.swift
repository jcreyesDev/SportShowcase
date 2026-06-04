import SwiftUI

enum DSAvatarSize {
    case xs
    case sm
    case md
    case lg
    case xl
    
    var dimension: CGFloat {
        switch self {
            case .xs: return 24
            case .sm: return 32
            case .md: return 44
            case .lg: return 64
            case .xl: return 88
        }
    }
    
    var fontSize: Font {
        switch self {
            case .xs: return DSFont.caption
            case .sm: return DSFont.footnote
            case .md: return DSFont.subheadline
            case .lg: return DSFont.title2
            case .xl: return DSFont.largeTitle
        }
    }
}

enum DSAvatarStyle {
    case image(String)
    case initials(String)
    case icon(String)
    case placeholder
}

struct DSAvatar: View {
    
    var style: DSAvatarStyle     = .placeholder
    var size: DSAvatarSize       = .md
    var tintColor: Color         = DSColor.accent
    var showBadge: Bool          = false
    var badgeColor: Color        = DSColor.Semantic.success
    var borderColor: Color?      = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .overlay(Circle()
                    .strokeBorder(borderColor ?? Color.clear,
                                  lineWidth: borderColor != nil ? 2 : 0))
            
            if showBadge {
                Circle()
                    .fill(badgeColor)
                    .frame(width: size.dimension * 0.28,
                           height: size.dimension * 0.28)
                    .overlay(Circle()
                        .strokeBorder(DSColor.Background.card, lineWidth: 2))
            }
        }
    }
    
    @ViewBuilder
    private var avatarContent: some View {
        switch style {
            case .image(let url):
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeholderView
                }
                
            case .initials(let name):
                ZStack {
                    tintColor.opacity(0.15)
                    Text(initials(from: name))
                        .font(size.fontSize)
                        .fontWeight(.medium)
                        .foregroundStyle(tintColor)
                }
                
            case .icon(let systemName):
                ZStack {
                    tintColor.opacity(0.15)
                    Image(systemName: systemName)
                        .font(size.fontSize)
                        .foregroundStyle(tintColor)
                }
                
            case .placeholder:
                placeholderView
        }
    }
    
    private var placeholderView: some View {
        ZStack {
            DSColor.Text.tertiary.opacity(0.12)
            Image(systemName: "person.fill")
                .font(size.fontSize)
                .foregroundStyle(DSColor.Text.tertiary)
        }
    }
    
    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        // Sizes
        HStack(spacing: DSSpacing.md) {
            DSAvatar(style: .initials("Kylian Mbappé"), size: .xs, tintColor: DSColor.accent)
            DSAvatar(style: .initials("Kylian Mbappé"), size: .sm, tintColor: DSColor.accent)
            DSAvatar(style: .initials("Kylian Mbappé"), size: .md, tintColor: DSColor.accent)
            DSAvatar(style: .initials("Kylian Mbappé"), size: .lg, tintColor: DSColor.accent)
            DSAvatar(style: .initials("Kylian Mbappé"), size: .xl, tintColor: DSColor.accent)
        }
        
        // Styles
        HStack(spacing: DSSpacing.md) {
            DSAvatar(style: .image("https://media.api-sports.io/football/players/278.png"),
                     size: .lg)
            DSAvatar(style: .initials("Real Madrid"),
                     size: .lg,
                     tintColor: DSColor.secondary)
            DSAvatar(style: .icon("shield.fill"),
                     size: .lg,
                     tintColor: DSColor.Semantic.success)
            DSAvatar(style: .placeholder, size: .lg)
        }
        
        // With badge + border
        HStack(spacing: DSSpacing.md) {
            DSAvatar(style: .image("https://media.api-sports.io/football/players/278.png"),
                     size: .lg,
                     showBadge: true,
                     badgeColor: DSColor.Semantic.success,
                     borderColor: DSColor.accent)
            DSAvatar(style: .initials("Vinicius Jr"),
                     size: .lg,
                     tintColor: DSColor.accent,
                     showBadge: true,
                     badgeColor: DSColor.Semantic.warning)
        }
    }
    .padding(DSSpacing.lg)
}
