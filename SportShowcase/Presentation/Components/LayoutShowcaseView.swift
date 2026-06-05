    //
    //  LayoutShowcaseView.swift
    //  SportShowcase
    //

import SwiftUI

struct LayoutShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct LayoutComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        LayoutComponent(id: 0, name: "Avatar"),
        LayoutComponent(id: 1, name: "Divider"),
        LayoutComponent(id: 2, name: "Chip"),
        LayoutComponent(id: 3, name: "Badge")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: DSSpacing.xs) {
                Text(components[currentPage].name)
                    .font(DSFont.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                
                DSPageIndicator(currentPage: $currentPage,
                                pageCount: components.count,
                                style: .dots,
                                tintColor: DSColor.accent)
            }
            .padding(.vertical, DSSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(DSColor.Background.card)
            
            DSDivider()
            
            TabView(selection: $currentPage) {
                ForEach(components) { component in
                    ScrollView {
                        playgroundContent(for: component.id)
                            .padding(.bottom, DSSpacing.xl)
                    }
                    .tag(component.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: currentPage)
        }
        .navigationTitle("Layout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: AvatarPlayground()
            case 1: DividerPlayground()
            case 2: ChipPlayground()
            case 3: BadgePlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - Avatar Playground
private struct AvatarPlayground: View {
    
    @State private var styleIdx  = 0
    @State private var sizeIdx   = 2
    @State private var showBadge = false
    @State private var colorIdx  = 0
    
    private let styleNames = ["Image", "Initials", "Icon", "Placeholder"]
    private let sizes: [DSAvatarSize] = [.xs, .sm, .md, .lg, .xl]
    private let sizeNames = ["XS", "SM", "MD", "LG", "XL"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Sec.", "OK", "Error"]
    
    private let info = ComponentInfo(
        name: "Avatar",
        description: "Avatars represent users, teams, or entities with an image, initials, icon, or placeholder.",
        usageScenarios: [
            UsageScenario(icon: "person.circle", title: "User representation",
                          description: "Show player or user identity in lists and profiles."),
            UsageScenario(icon: "shield", title: "Team identity",
                          description: "Display team logos or initials in compact spaces.")
        ],
        configurability: "4 styles, 5 sizes, optional badge, custom tint and border colors.",
        bestPractices: [
            "Always provide a fallback for when images fail to load.",
            "Use initials as fallback when no image is available.",
            "Use badge to indicate online status or notifications."
        ]
    )
    
    private var avatarStyle: DSAvatarStyle {
        switch styleIdx {
            case 0: return .image("https://media.api-sports.io/football/players/278.png")
            case 1: return .initials("Kylian Mbappé")
            case 2: return .icon("shield.fill")
            default: return .placeholder
        }
    }
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSAvatar(style: avatarStyle,
                     size: sizes[sizeIdx],
                     tintColor: colors[colorIdx],
                     showBadge: showBadge,
                     badgeColor: DSColor.Semantic.success)
            .id("\(styleIdx)-\(sizeIdx)-\(colorIdx)")
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Size", options: sizeNames, selected: $sizeIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactToggleRow(title: "Show badge", isOn: $showBadge)
        }
    }
}

    // MARK: - Divider Playground
private struct DividerPlayground: View {
    
    @State private var styleIdx       = 0
    @State private var orientationIdx = 0
    @State private var showLabel      = false
    @State private var colorIdx       = 0
    
    private let styles: [DSDividerStyle] = [.solid, .dashed, .dotted, .gradient]
    private let styleNames = ["Solid", "Dashed", "Dotted", "Gradient"]
    private let orientationNames = ["Horizontal", "Vertical"]
    private let colors: [Color] = [DSColor.Text.tertiary.opacity(0.3),
                                   DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success]
    private let colorNames = ["Default", "Accent", "Sec.", "OK"]
    
    private let info = ComponentInfo(
        name: "Divider",
        description: "Dividers separate content sections visually. They can be horizontal, vertical, or labeled.",
        usageScenarios: [
            UsageScenario(icon: "line.horizontal.3", title: "Section separation",
                          description: "Separate groups of related items in lists or forms."),
            UsageScenario(icon: "text.aligncenter", title: "Labeled divider",
                          description: "Use with a label like 'OR' to separate alternative actions.")
        ],
        configurability: "4 styles, horizontal/vertical orientation, optional center label, custom color.",
        bestPractices: [
            "Use sparingly — too many dividers create visual noise.",
            "Prefer whitespace over dividers when possible.",
            "Use labeled dividers for form sections or alternative actions."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if orientationIdx == 0 {
                DSDivider(style: styles[styleIdx],
                          color: colors[colorIdx],
                          label: showLabel ? "OR" : nil)
            } else {
                HStack(spacing: DSSpacing.lg) {
                    Text("Left")
                        .font(DSFont.subheadline)
                        .foregroundStyle(DSColor.Text.primary)
                    DSDivider(style: styles[styleIdx],
                              orientation: .vertical,
                              color: colors[colorIdx])
                    .frame(height: 40)
                    Text("Right")
                        .font(DSFont.subheadline)
                        .foregroundStyle(DSColor.Text.primary)
                }
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Orient.", options: orientationNames, selected: $orientationIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactToggleRow(title: "Show label", isOn: $showLabel)
        }
    }
}

    // MARK: - Chip Playground
private struct ChipPlayground: View {
    
    @State private var styleIdx   = 0
    @State private var showIcon   = false
    @State private var isSelected = false
    @State private var isDisabled = false
    @State private var colorIdx   = 0
    
    private let styles: [DSChipStyle] = [.filled, .outlined, .glass]
    private let styleNames = ["Filled", "Outlined", "Glass"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Sec.", "OK", "Error"]
    
    private let info = ComponentInfo(
        name: "Chip",
        description: "Chips are compact elements that represent attributes, filters, or actions. They can be selected or removed.",
        usageScenarios: [
            UsageScenario(icon: "tag", title: "Filters",
                          description: "Use chip groups for multi-select filters in search screens."),
            UsageScenario(icon: "checkmark", title: "Selection",
                          description: "Indicate selected categories, positions, or tags.")
        ],
        configurability: "3 styles, optional icon, selectable, removable, disabled state, custom tint.",
        bestPractices: [
            "Use in horizontal scrollable rows for long lists of options.",
            "Show selected state clearly with filled background.",
            "Use remove button only when the chip represents a chosen filter."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSChip(title: "Premier League",
                   style: styles[styleIdx],
                   icon: showIcon ? "trophy" : nil,
                   isSelected: isSelected,
                   isDisabled: isDisabled,
                   tintColor: colors[colorIdx])
            .id("\(styleIdx)-\(colorIdx)")
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactToggleRow(title: "Show icon", isOn: $showIcon)
            CompactToggleRow(title: "Selected", isOn: $isSelected)
            CompactToggleRow(title: "Disabled", isOn: $isDisabled)
        }
    }
}

    // MARK: - Badge Playground
private struct BadgePlayground: View {
    
    @State private var styleIdx = 0
    @State private var showIcon = false
    
    private let styles: [DSBadgeStyle] = [.accent, .secondary, .success, .warning, .error, .neutral]
    private let styleNames = ["Accent", "Sec.", "OK", "Warn", "Err", "Neutral"]
    
    private let info = ComponentInfo(
        name: "Badge",
        description: "Badges are small labels that indicate status, category, or count. They appear inline with other content.",
        usageScenarios: [
            UsageScenario(icon: "tag", title: "Status labels",
                          description: "Show player status like Active, Injured, or Suspended."),
            UsageScenario(icon: "sportscourt", title: "Match status",
                          description: "Use DSStatusBadge for finished, live, and upcoming matches.")
        ],
        configurability: "6 styles, optional leading icon, customizable text.",
        bestPractices: [
            "Use consistent colors for the same status across the app.",
            "Keep badge text to 1-2 words maximum.",
            "Use icons to reinforce meaning when space allows."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSBadge(title: "Forward",
                    style: styles[styleIdx],
                    icon: showIcon ? "person.fill" : nil)
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactToggleRow(title: "Show icon", isOn: $showIcon)
        }
    }
}

    // MARK: - Conformances
extension DSDividerStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .solid:    return "Solid"
            case .dashed:   return "Dashed"
            case .dotted:   return "Dotted"
            case .gradient: return "Gradient"
        }
    }
}

extension DSChipStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .filled:   return "Filled"
            case .outlined: return "Outlined"
            case .glass:    return "Glass"
        }
    }
}

extension DSBadgeStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .accent:    return "Accent"
            case .secondary: return "Secondary"
            case .success:   return "Success"
            case .warning:   return "Warning"
            case .error:     return "Error"
            case .neutral:   return "Neutral"
        }
    }
}

extension DSAvatarSize: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .xs: return "XS"
            case .sm: return "SM"
            case .md: return "MD"
            case .lg: return "LG"
            case .xl: return "XL"
        }
    }
}

#Preview {
    NavigationStack {
        LayoutShowcaseView()
    }
}
