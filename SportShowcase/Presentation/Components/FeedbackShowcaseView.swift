import SwiftUI

struct FeedbackShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct FeedbackComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        FeedbackComponent(id: 0, name: "Loader"),
        FeedbackComponent(id: 1, name: "Progress Bar"),
        FeedbackComponent(id: 2, name: "Skeleton"),
        FeedbackComponent(id: 3, name: "Toast"),
        FeedbackComponent(id: 4, name: "Alert"),
        FeedbackComponent(id: 5, name: "Empty State")
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
            .pagerCoachMarkTarget(id: "cm_pager")
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
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: LoaderPlayground()
            case 1: ProgressBarPlayground()
            case 2: SkeletonPlayground()
            case 3: ToastPlayground()
            case 4: AlertPlayground()
            case 5: EmptyStatePlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - Loader Playground
private struct LoaderPlayground: View {
    
    @State private var styleIdx = 0
    @State private var sizeIdx  = 1
    @State private var colorIdx = 0
    
    private let styles: [DSLoaderStyle] = [.circular, .linear, .pulse, .bounce]
    private let styleNames = ["Circular", "Linear", "Pulse", "Bounce"]
    private let sizes: [DSLoaderSize] = [.small, .medium, .large]
    private let sizeNames = ["Small", "Medium", "Large"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Secondary", "Success", "Error"]
    
    private let info = ComponentInfo(
        name: "Loader",
        description: "Loaders indicate that content is being loaded or an action is processing. Use when wait time is unknown.",
        usageScenarios: [
            UsageScenario(icon: "arrow.down.circle", title: "Data loading",
                          description: "Show while fetching data from a server."),
            UsageScenario(icon: "arrow.2.circlepath", title: "Processing",
                          description: "Show during background operations like uploads.")
        ],
        configurability: "4 styles, 3 sizes, custom tint color, optional label.",
        bestPractices: [
            "Use circular for most cases — it's the most recognizable.",
            "Always pair with a message if the wait exceeds 3 seconds.",
            "Never block the UI with a loader if partial content can be shown."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSLoader(style: styles[styleIdx],
                     size: sizes[sizeIdx],
                     tintColor: colors[colorIdx],
                     label: "Loading...")
            .id("\(styleIdx)-\(sizeIdx)-\(colorIdx)")
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Size", options: sizeNames, selected: $sizeIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
        }
    }
}

    // MARK: - Progress Bar Playground
private struct ProgressBarPlayground: View {
    
    @State private var progress: Double = 0.65
    @State private var styleIdx  = 0
    @State private var colorIdx  = 0
    @State private var isRunning = false
    
    private let styles: [DSProgressStyle] = [.bar, .circle, .barWithLabel]
    private let styleNames = ["Bar", "Circle", "Bar + Label"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Secondary", "Success", "Error"]
    
    private let info = ComponentInfo(
        name: "Progress Bar",
        description: "Progress bars show the completion status of a task with a known duration or steps.",
        usageScenarios: [
            UsageScenario(icon: "arrow.down.circle", title: "File downloads",
                          description: "Show download or upload progress with exact percentage."),
            UsageScenario(icon: "checklist", title: "Multi-step tasks",
                          description: "Indicate progress through a multi-step form or process.")
        ],
        configurability: "3 styles, custom tint and track color, percentage display toggle, animated.",
        bestPractices: [
            "Use only when you know the exact progress percentage.",
            "Always show the percentage value for clarity.",
            "Animate smoothly — abrupt jumps feel broken."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSProgressBar(progress: $progress,
                          style: styles[styleIdx],
                          tintColor: colors[colorIdx],
                          label: "Downloading...")
            .frame(maxWidth: styles[styleIdx] == .circle ? 120 : .infinity)
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            ControlRow(title: "Progress") {
                HStack(spacing: DSSpacing.sm) {
                    DSButton(title: isRunning ? "Running..." : "Simulate",
                             style: .filled,
                             size: .small,
                             isLoading: isRunning) {
                        simulateProgress()
                    }
                    DSButton(title: "Reset",
                             style: .outlined,
                             size: .small) {
                        withAnimation { progress = 0 }
                        isRunning = false
                    }
                }
            }
        }
    }
    
    private func simulateProgress() {
        isRunning = true
        progress  = 0
        for i in 1...40 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                progress = Double(i) / 40.0
                if i == 40 { isRunning = false }
            }
        }
    }
}

    // MARK: - Skeleton Playground
private struct SkeletonPlayground: View {
    
    @State private var typeIdx    = 0
    @State private var showData   = false
    
    private let typeNames = ["Team Card", "Player Card", "Match Card"]
    
    private let info = ComponentInfo(
        name: "Skeleton",
        description: "Skeleton screens show a placeholder preview of content before data loads, reducing perceived wait time.",
        usageScenarios: [
            UsageScenario(icon: "rectangle.stack", title: "Content loading",
                          description: "Show while fetching lists of teams, players, or matches."),
            UsageScenario(icon: "eye", title: "Perceived performance",
                          description: "Improves UX by showing structure before content arrives.")
        ],
        configurability: "Custom shapes matching real content layout. Shimmer animation built-in.",
        bestPractices: [
            "Match the skeleton layout to the actual content as closely as possible.",
            "Use shimmer animation to indicate active loading.",
            "Transition smoothly from skeleton to real content."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            Group {
                if showData {
                    Text("Data loaded!")
                        .font(DSFont.subheadline)
                        .foregroundStyle(DSColor.Semantic.success)
                        .transition(.opacity)
                } else {
                    skeletonContent
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showData)
        } controls: {
            CompactControlRow(title: "Type", options: typeNames, selected: $typeIdx)
            CompactToggleRow(title: "Show data", isOn: $showData)
        }
    }
    
    @ViewBuilder
    private var skeletonContent: some View {
        switch typeIdx {
            case 0: DSTeamCardSkeleton()
            case 1: DSPlayerCardSkeleton()
            case 2: DSMatchCardSkeleton()
            default: DSTeamCardSkeleton()
        }
    }
}

    // MARK: - Toast Playground
private struct ToastPlayground: View {
    
    @State private var typeIdx    = 0
    @State private var posIdx     = 0
    @State private var toast: DSToastData?
    
    private let types: [DSToastType] = [.success, .error, .warning, .info]
    private let typeNames = ["Success", "Error", "Warning", "Info"]
    private let posNames = ["Top", "Bottom"]
    
    private let info = ComponentInfo(
        name: "Toast",
        description: "Toasts are brief, non-disruptive messages that appear temporarily to provide feedback about an operation.",
        usageScenarios: [
            UsageScenario(icon: "checkmark.circle", title: "Action feedback",
                          description: "Confirm that an action completed successfully."),
            UsageScenario(icon: "exclamationmark.circle", title: "Error feedback",
                          description: "Inform users of errors without blocking the UI.")
        ],
        configurability: "4 types (success, error, warning, info), top/bottom position, custom duration.",
        bestPractices: [
            "Keep messages short — one sentence maximum.",
            "Use success for confirmations, error for failures.",
            "Auto-dismiss after 3 seconds for non-critical messages."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSButton(title: "Show Toast",
                     style: .filled,
                     icon: "bell",
                     isFullWidth: true) {
                toast = DSToastData(message: toastMessage,
                                    type: types[typeIdx])
            }
        } controls: {
            CompactControlRow(title: "Type", options: typeNames, selected: $typeIdx)
            CompactControlRow(title: "Position", options: posNames, selected: $posIdx)
        }
        .dsToast($toast, position: posIdx == 0 ? .top : .bottom)
    }
    
    private var toastMessage: String {
        switch typeIdx {
            case 0: return "Player added to favorites!"
            case 1: return "Failed to load match data"
            case 2: return "Connection is slow"
            default: return "Match starts in 10 minutes"
        }
    }
}

    // MARK: - Alert Playground
private struct AlertPlayground: View {
    
    @State private var styleIdx   = 0
    @State private var showAlert  = false
    
    private let styles: [DSAlertStyle] = [.info, .success, .warning, .destructive]
    private let styleNames = ["Info", "Success", "Warning", "Destr."]
    
    private let info = ComponentInfo(
        name: "Alert",
        description: "Alerts interrupt the user to present critical information or require a decision before proceeding.",
        usageScenarios: [
            UsageScenario(icon: "info.circle", title: "Important info",
                          description: "Inform users of critical updates or changes."),
            UsageScenario(icon: "trash", title: "Destructive confirmation",
                          description: "Confirm before permanently deleting or removing data.")
        ],
        configurability: "4 styles, custom icon, primary and secondary actions.",
        bestPractices: [
            "Use sparingly — alerts interrupt the user experience.",
            "Always provide a way to dismiss or cancel.",
            "Keep messages concise and action-oriented."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSButton(title: "Show Alert",
                     style: .filled,
                     icon: "bell.badge",
                     isFullWidth: true) {
                showAlert = true
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
        }
        .dsAlert(isPresented: $showAlert) {
            DSAlert(title: alertTitle,
                    message: alertMessage,
                    style: styles[styleIdx],
                    primaryAction: DSAlertAction(title: "Confirm",
                                                 style: .filled,
                                                 action: {}),
                    secondaryAction: DSAlertAction(title: "Cancel",
                                                   style: .ghost,
                                                   action: {}),
                    isPresented: $showAlert)
        }
    }
    
    private var alertTitle: String {
        switch styleIdx {
            case 0: return "Match Update"
            case 1: return "Player Added!"
            case 2: return "Slow Connection"
            default: return "Remove Favorite"
        }
    }
    
    private var alertMessage: String {
        switch styleIdx {
            case 0: return "Real Madrid vs Barcelona has been rescheduled."
            case 1: return "Mbappé has been added to your favorites."
            case 2: return "Data may not be up to date. Check your connection."
            default: return "Are you sure you want to remove this team?"
        }
    }
}

    // MARK: - Empty State Playground
private struct EmptyStatePlayground: View {
    
    @State private var styleIdx = 0
    @State private var iconIdx  = 0
    
    private let styles: [DSEmptyStateStyle] = [.standard, .compact, .fullScreen]
    private let styleNames = ["Standard", "Compact", "Full Screen"]
    private let icons = ["sportscourt", "heart", "person.2", "shield", "magnifyingglass"]
    private let iconNames = ["Sport", "Heart", "People", "Shield", "Search"]
    
    private let info = ComponentInfo(
        name: "Empty State",
        description: "Empty states appear when a list or page has no content to show. They guide users on what to do next.",
        usageScenarios: [
            UsageScenario(icon: "magnifyingglass", title: "No search results",
                          description: "Show when a search or filter returns no matches."),
            UsageScenario(icon: "heart", title: "No favorites",
                          description: "Encourage users to add content when a list is empty.")
        ],
        configurability: "3 styles, custom icon, title, message, and action button.",
        bestPractices: [
            "Always provide a clear call-to-action in the empty state.",
            "Use illustrations or icons to make empty states more friendly.",
            "Explain why the state is empty and what the user can do."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSEmptyState(title: "No matches found",
                         message: "Try adjusting your search or filters",
                         icon: icons[iconIdx],
                         style: styles[styleIdx],
                         actionTitle: "Clear filters",
                         onAction: {},
                         iconColor: DSColor.accent)
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Icon", options: iconNames, selected: $iconIdx)
        }
    }
}

    // MARK: - DSProgressStyle conformance
extension DSProgressStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .bar:          return "Bar"
            case .circle:       return "Circle"
            case .barWithLabel: return "Bar + Label"
        }
    }
}

extension DSLoaderStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .circular: return "Circular"
            case .linear:   return "Linear"
            case .pulse:    return "Pulse"
            case .bounce:   return "Bounce"
        }
    }
}

extension DSLoaderSize: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .small:  return "Small"
            case .medium: return "Medium"
            case .large:  return "Large"
        }
    }
}

extension DSAlertStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .info:        return "Info"
            case .success:     return "Success"
            case .warning:     return "Warning"
            case .destructive: return "Destructive"
        }
    }
}

extension DSEmptyStateStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .standard:   return "Standard"
            case .compact:    return "Compact"
            case .fullScreen: return "Full Screen"
        }
    }
}

#Preview {
    NavigationStack {
        FeedbackShowcaseView()
    }
}
