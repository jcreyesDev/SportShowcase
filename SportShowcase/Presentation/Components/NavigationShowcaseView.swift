import SwiftUI

struct NavigationShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct NavComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        NavComponent(id: 0, name: "Segmented Control"),
        NavComponent(id: 1, name: "Page Indicator"),
        NavComponent(id: 2, name: "Breadcrumb")
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
        .navigationTitle("Navigation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: SegmentedControlPlayground()
            case 1: PageIndicatorPlayground()
            case 2: BreadcrumbPlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - Segmented Control Playground
private struct SegmentedControlPlayground: View {
    
    @State private var styleIdx    = 0
    @State private var colorIdx    = 0
    @State private var selected    = "All"
    @State private var fullWidth   = true
    
    private let styles: [DSSegmentedStyle] = [.pill, .underline, .standard]
    private let styleNames = ["Pill", "Underline", "Standard"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Sec.", "OK", "Error"]
    private let options = ["All", "Live", "Upcoming", "Finished"]
    
    private let info = ComponentInfo(
        name: "Segmented Control",
        description: "Segmented controls allow users to select one option from a small set of mutually exclusive choices.",
        usageScenarios: [
            UsageScenario(icon: "sportscourt", title: "Match filtering",
                          description: "Filter matches by status: all, live, upcoming, finished."),
            UsageScenario(icon: "chart.bar", title: "View switching",
                          description: "Switch between different data views or time periods.")
        ],
        configurability: "3 styles (pill, underline, standard), custom tint, full-width option.",
        bestPractices: [
            "Use for 2-5 options maximum.",
            "Keep labels short — one or two words.",
            "Use pill style for modern floating appearance."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSSegmentedControl(selection: $selected,
                               options: options,
                               style: styles[styleIdx],
                               tintColor: colors[colorIdx],
                               fullWidth: fullWidth)
            .id("\(styleIdx)-\(colorIdx)")
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactToggleRow(title: "Full width", isOn: $fullWidth)
            CompactValueRow(title: "Selected", value: selected)
        }
    }
}

    // MARK: - Page Indicator Playground
private struct PageIndicatorPlayground: View {
    
    @State private var indicatorStyleIdx = 0
    @State private var colorIdx          = 0
    @State private var currentPage       = 0
    
    private let styles: [DSPageIndicatorStyle] = [.dots, .pills, .dashes, .numbers]
    private let styleNames = ["Dots", "Pills", "Dashes", "Numbers"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Sec.", "OK", "Error"]
    
    private struct PageItem: Identifiable {
        let id: Int
        let name: String
        let logo: String
    }
    
    private let pages = [
        PageItem(id: 0, name: "Real Madrid",    logo: "https://media.api-sports.io/football/teams/541.png"),
        PageItem(id: 1, name: "FC Barcelona",   logo: "https://media.api-sports.io/football/teams/529.png"),
        PageItem(id: 2, name: "Atletico Madrid",logo: "https://media.api-sports.io/football/teams/530.png"),
        PageItem(id: 3, name: "Sevilla FC",     logo: "https://media.api-sports.io/football/teams/536.png")
    ]
    
    private let info = ComponentInfo(
        name: "Page Indicator",
        description: "Page indicators show the current position within a paginated sequence of content.",
        usageScenarios: [
            UsageScenario(icon: "rectangle.stack", title: "Carousels",
                          description: "Show position in image carousels or card swipe flows."),
            UsageScenario(icon: "list.number", title: "Onboarding",
                          description: "Indicate progress through onboarding or tutorial screens.")
        ],
        configurability: "4 styles (dots, pills, dashes, numbers), custom tint, animated transitions.",
        bestPractices: [
            "Use dots for small page counts (2-5).",
            "Use numbers for larger collections where position matters.",
            "Place below the content it represents."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            VStack(spacing: DSSpacing.lg) {
                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        DSCard(style: .elevated) {
                            HStack(spacing: DSSpacing.md) {
                                AsyncImage(url: URL(string: page.logo)) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Circle().fill(DSColor.surface)
                                }
                                .frame(width: 44, height: 44)
                                Text(page.name)
                                    .font(DSFont.headline)
                                    .foregroundStyle(DSColor.Text.primary)
                                Spacer()
                            }
                        }
                        .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 90)
                
                DSPageIndicator(currentPage: $currentPage,
                                pageCount: pages.count,
                                style: styles[indicatorStyleIdx],
                                tintColor: colors[colorIdx])
            }
            .id("\(indicatorStyleIdx)-\(colorIdx)")
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $indicatorStyleIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactValueRow(title: "Current page", value: "\(currentPage + 1) / \(pages.count)")
        }
    }
}

    // MARK: - Breadcrumb Playground
private struct BreadcrumbPlayground: View {
    
    @State private var levelIdx    = 2
    @State private var colorIdx    = 0
    @State private var separatorIdx = 0
    
    private let levelNames = ["1 level", "2 levels", "3 levels", "4 levels"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success]
    private let colorNames = ["Accent", "Sec.", "OK"]
    private let separators = ["chevron.right", "chevron.right.2", "arrow.right"]
    private let separatorNames = ["Single", "Double", "Arrow"]
    
    private let info = ComponentInfo(
        name: "Breadcrumb",
        description: "Breadcrumbs show the user's current location within the app hierarchy and allow navigation to parent levels.",
        usageScenarios: [
            UsageScenario(icon: "map", title: "Deep navigation",
                          description: "Show the path in deep hierarchies like League > Team > Player."),
            UsageScenario(icon: "arrow.left", title: "Quick navigation",
                          description: "Allow users to jump to any parent level with a single tap.")
        ],
        configurability: "Custom items, separator style, tint color. Auto-scrolls for long paths.",
        bestPractices: [
            "Show breadcrumbs only when navigation depth is 3+ levels.",
            "Keep item labels short — truncate if needed.",
            "The last item (current page) should not be tappable."
        ]
    )
    
    private var breadcrumbItems: [DSBreadcrumbItem] {
        let allItems = [
            DSBreadcrumbItem(id: "1", title: "Home", icon: "house", onTap: {}),
            DSBreadcrumbItem(id: "2", title: "Leagues", onTap: {}),
            DSBreadcrumbItem(id: "3", title: "La Liga", onTap: {}),
            DSBreadcrumbItem(id: "4", title: "Real Madrid")
        ]
        return Array(allItems.prefix(levelIdx + 1))
    }
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSBreadcrumb(items: breadcrumbItems,
                         tintColor: colors[colorIdx],
                         separator: separators[separatorIdx])
        } controls: {
            CompactControlRow(title: "Depth", options: levelNames, selected: $levelIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactControlRow(title: "Separator", options: separatorNames, selected: $separatorIdx)
        }
    }
}

    // MARK: - Conformances
extension DSSegmentedStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .standard:  return "Standard"
            case .pill:      return "Pill"
            case .underline: return "Underline"
        }
    }
}

extension DSPageIndicatorStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .dots:    return "Dots"
            case .pills:   return "Pills"
            case .dashes:  return "Dashes"
            case .numbers: return "Numbers"
        }
    }
}

#Preview {
    NavigationStack {
        NavigationShowcaseView()
    }
}
