import SwiftUI

struct ButtonShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct ButtonComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        ButtonComponent(id: 0, name: "Button"),
        ButtonComponent(id: 1, name: "Slide to Confirm")
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
        .navigationTitle("Buttons")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: ButtonPlayground()
            case 1: SlideToConfirmPlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - Button Playground
private struct ButtonPlayground: View {
    
    @State private var styleIdx    = 0
    @State private var sizeIdx     = 0
    @State private var showIcon    = false
    @State private var isFullWidth = false
    @State private var isLoading   = false
    @State private var isDisabled  = false
    @State private var colorIdx    = 0
    @State private var toast: DSToastData?
    
    private let styles: [DSButtonStyle] = [.filled, .outlined, .ghost, .destructive]
    private let styleNames = ["Filled", "Outlined", "Ghost", "Destr."]
    private let sizes: [DSButtonSize] = [.small, .medium, .large]
    private let sizeNames = ["Small", "Medium", "Large"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Secondary", "Success", "Error"]
    
    private let info = ComponentInfo(
        name: "Button",
        description: "Buttons communicate actions that users can take. Typically placed in forms, dialogs, and toolbars.",
        usageScenarios: [
            UsageScenario(icon: "hand.tap", title: "Primary actions",
                          description: "Use filled buttons for the most important action on a screen."),
            UsageScenario(icon: "trash", title: "Destructive actions",
                          description: "Use destructive style for irreversible actions like Delete.")
        ],
        configurability: "4 styles, 3 sizes, leading/trailing icons, loading, disabled, custom tint, full-width.",
        bestPractices: [
            "Use only one primary (filled) button per screen section.",
            "Keep labels short and action-oriented.",
            "Always show loading state during async operations."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSButton(title: "Button",
                     style: styles[styleIdx],
                     size: sizes[sizeIdx],
                     icon: showIcon ? "star.fill" : nil,
                     isFullWidth: isFullWidth,
                     isLoading: isLoading,
                     isDisabled: isDisabled,
                     tintColor: colors[colorIdx]) {
                toast = DSToastData(message: "Button tapped!", type: .success)
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Size", options: sizeNames, selected: $sizeIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactToggleRow(title: "Show icon", isOn: $showIcon)
            CompactToggleRow(title: "Full width", isOn: $isFullWidth)
            CompactToggleRow(title: "Loading", isOn: $isLoading)
            CompactToggleRow(title: "Disabled", isOn: $isDisabled)
        }
        .dsToast($toast)
    }
}

    // MARK: - Slide to Confirm Playground
private struct SlideToConfirmPlayground: View {
    
    @State private var styleIdx = 0
    @State private var toast: DSToastData?
    
    private let styles: [DSButtonStyle] = [.filled, .destructive]
    private let styleNames = ["Filled", "Destructive"]
    
    private let info = ComponentInfo(
        name: "Slide to Confirm",
        description: "A high-friction confirmation pattern for critical or irreversible actions. Requires intentional user effort.",
        usageScenarios: [
            UsageScenario(icon: "checkmark.shield", title: "Critical confirmations",
                          description: "Confirm payments, transfers, or permanent deletions."),
            UsageScenario(icon: "exclamationmark.triangle", title: "Destructive actions",
                          description: "Use destructive style when the action cannot be undone.")
        ],
        configurability: "2 styles (filled, destructive), custom title, subtitle, and icons.",
        bestPractices: [
            "Reserve for truly critical actions — overuse reduces its effectiveness.",
            "Always explain what will happen in the subtitle.",
            "Provide haptic feedback at completion."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSSlideToConfirmButton(
                title: styleIdx == 1 ? L10n.Button.slideToDelete : L10n.Button.slideToConfirm,
                subtitle: styleIdx == 1 ? L10n.Button.deletePermanently : L10n.Button.cannotUndo,
                style: styles[styleIdx]) {
                    toast = DSToastData(message: styleIdx == 1 ? "Deleted!" : "Confirmed!",
                                        type: styleIdx == 1 ? .error : .success)
                }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
        }
        .dsToast($toast)
    }
}

#Preview {
    NavigationStack {
        ButtonShowcaseView()
    }
}
