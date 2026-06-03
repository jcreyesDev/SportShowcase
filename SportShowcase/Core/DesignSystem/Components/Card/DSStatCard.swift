import SwiftUI

struct DSStatCard: View {
    
    let value: String
    let label: String
    var icon: String?          = nil
    var style: DSCardStyle     = .elevated
    var accentColor: Color     = DSColor.accent
    var trend: DSTrend?        = nil
    
    var body: some View {
        DSCard(style: style, padding: DSSpacing.lg) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                
                // MARK: Icon + trend
                HStack {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundStyle(accentColor)
                    }
                    Spacer()
                    if let trend {
                        TrendBadge(trend: trend)
                    }
                }
                
                // MARK: Value
                Text(value)
                    .font(DSFont.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(DSColor.Text.primary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                // MARK: Label
                Text(label)
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Text.secondary)
                    .lineLimit(2)
            }
        }
    }
}

// MARK: - Trend
enum DSTrend {
    case up(String)
    case down(String)
    case neutral(String)
    
    var icon: String {
        switch self {
            case .up:      return "arrow.up.right"
            case .down:    return "arrow.down.right"
            case .neutral: return "arrow.right"
        }
    }
    
    var color: Color {
        switch self {
            case .up:      return DSColor.Semantic.success
            case .down:    return DSColor.Semantic.error
            case .neutral: return DSColor.Text.tertiary
        }
    }
    
    var text: String {
        switch self {
            case .up(let t), .down(let t), .neutral(let t): return t
        }
    }
}

// MARK: - Trend Badge
private struct TrendBadge: View {
    let trend: DSTrend
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: trend.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(trend.text)
                .font(DSFont.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(trend.color)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, 3)
        .background(trend.color.opacity(0.12))
        .clipShape(Capsule())
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DSSpacing.md) {
        DSStatCard(value: "31",
                   label: "Goals",
                   icon: "soccerball",
                   style: .elevated,
                   accentColor: DSColor.accent,
                   trend: .up("+4"))
        
        DSStatCard(value: "7",
                   label: "Assists",
                   icon: "hand.point.right",
                   style: .elevated,
                   accentColor: DSColor.secondary,
                   trend: .up("+1"))
        
        DSStatCard(value: "35",
                   label: "Matches played",
                   icon: "sportscourt",
                   style: .filled,
                   accentColor: DSColor.Text.secondary)
        
        DSStatCard(value: "89%",
                   label: "Pass accuracy",
                   icon: "checkmark.circle",
                   style: .glass,
                   accentColor: DSColor.Semantic.success,
                   trend: .down("-2%"))
    }
    .padding(DSSpacing.lg)
}
