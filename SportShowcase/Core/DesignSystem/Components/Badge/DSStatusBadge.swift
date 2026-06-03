import SwiftUI

struct DSStatusBadge: View {
    
    let status: String
    
    var body: some View {
        DSBadge(title: localizedStatus,
                style: badgeStyle,
                icon: statusIcon)
    }
    
    private var localizedStatus: String {
        switch status.lowercased() {
            case "finished": return L10n.Match.finished
            case "upcoming": return L10n.Match.upcoming
            case "live":     return L10n.Match.live
            default:         return status.capitalized
        }
    }
    
    private var badgeStyle: DSBadgeStyle {
        switch status.lowercased() {
            case "finished": return .neutral
            case "upcoming": return .accent
            case "live":     return .success
            default:         return .neutral
        }
    }
    
    private var statusIcon: String {
        switch status.lowercased() {
            case "finished": return "checkmark.circle"
            case "upcoming": return "clock"
            case "live":     return "dot.radiowaves.left.and.right"
            default:         return "questionmark.circle"
        }
    }
}

#Preview {
    HStack(spacing: DSSpacing.md) {
        DSStatusBadge(status: "finished")
        DSStatusBadge(status: "upcoming")
        DSStatusBadge(status: "live")
    }
    .padding(DSSpacing.lg)
}
