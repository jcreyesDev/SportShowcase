import SwiftUI

    // MARK: - Coach Mark Step
struct DSCoachMarkStep: Identifiable {
    let id: String
    let title: String
    let message: String
}

    // MARK: - Anchor preference
struct DSCoachMarkAnchor: Equatable {
    let id: String
    let frame: CGRect
}

struct DSCoachMarkPreferenceKey: PreferenceKey {
    static var defaultValue: [DSCoachMarkAnchor] = []
    static func reduce(value: inout [DSCoachMarkAnchor],
                       nextValue: () -> [DSCoachMarkAnchor]) {
        value.append(contentsOf: nextValue())
    }
}

    // MARK: - Target modifier
struct DSCoachMarkTargetModifier: ViewModifier {
    let id: String
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                Color.clear
                    .preference(key: DSCoachMarkPreferenceKey.self,
                                value: [DSCoachMarkAnchor(id: id,
                                                          frame: geo.frame(in: .global))])
            })
    }
}

extension View {
    func coachMarkTarget(id: String) -> some View {
        modifier(DSCoachMarkTargetModifier(id: id))
    }
}

    // MARK: - Manager
@Observable
class DSCoachMarkManager {
    
    static let shared = DSCoachMarkManager()
    var isActive      = false
    var stepIndex     = 0
    var steps:   [DSCoachMarkStep]  = []
    var anchors: [DSCoachMarkAnchor] = []
    private let storageKey = "coachmark_done"
    
    private init() {}
    
    var currentStep: DSCoachMarkStep? {
        guard stepIndex < steps.count else { return nil }
        return steps[stepIndex]
    }
    
    var currentAnchor: DSCoachMarkAnchor? {
        guard let step = currentStep else { return nil }
        return anchors.first { $0.id == step.id }
    }
    
    var progress: Double {
        steps.isEmpty ? 0 : Double(stepIndex + 1) / Double(steps.count)
    }
    
    func start(steps: [DSCoachMarkStep], key: String) {
        guard !isDone(key) else { return }
        self.steps = steps
        stepIndex  = 0
        isActive   = true
    }
    
    func next(key: String) {
        if stepIndex < steps.count - 1 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                stepIndex += 1
            }
        } else {
            finish(key: key)
        }
    }
    
    func skip(key: String) { finish(key: key) }
    
    func reset(key: String) {
        var done = doneKeys()
        done.removeAll { $0 == key }
        UserDefaults.standard.set(done, forKey: storageKey)
        isActive = false
    }
    
    private func finish(key: String) {
        withAnimation(.easeOut(duration: 0.25)) { isActive = false }
        markDone(key)
    }
    
    private func isDone(_ key: String) -> Bool { doneKeys().contains(key) }
    
    private func markDone(_ key: String) {
        var done = doneKeys()
        done.append(key)
        UserDefaults.standard.set(done, forKey: storageKey)
    }
    
    private func doneKeys() -> [String] {
        UserDefaults.standard.stringArray(forKey: storageKey) ?? []
    }
}

    // MARK: - Overlay
struct DSCoachMarkOverlay: View {
    
    let onboardingKey: String
    
        // Acceso directo al singleton — @Observable lo trackea correctamente
    private var manager: DSCoachMarkManager { DSCoachMarkManager.shared }
    
    var body: some View {
            // TimelineView fuerza re-renders para que @Observable sea detectado
        TimelineView(.animation(minimumInterval: 0.1, paused: !manager.isActive)) { _ in
            if manager.isActive,
               let step   = manager.currentStep,
               let anchor = manager.currentAnchor {
                
                ZStack {
                    dimLayer(anchor: anchor)
                    GeometryReader { geo in
                        bubbleView(step: step,
                                   anchor: anchor,
                                   screenSize: geo.size)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8),
                           value: manager.stepIndex)
                .transition(.opacity)
            }
        }
    }
    
        // MARK: - Dim layer
    private func dimLayer(anchor: DSCoachMarkAnchor) -> some View {
        Color.black.opacity(0.65)
            .ignoresSafeArea()
            .mask {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    RoundedRectangle(cornerRadius: DSRadius.md)
                        .fill(Color.black)
                        .frame(width:  anchor.frame.width  + 20,
                               height: anchor.frame.height + 20)
                        .position(x: anchor.frame.midX,
                                  y: anchor.frame.midY)
                }
                .compositingGroup()
                .luminanceToAlpha()
            }
            .onTapGesture { manager.next(key: onboardingKey) }
    }
    
        // MARK: - Bubble
    private func bubbleView(step: DSCoachMarkStep,
                            anchor: DSCoachMarkAnchor,
                            screenSize: CGSize) -> some View {
        let bubbleW:    CGFloat = min(screenSize.width - 48, 300)
        let estimatedH: CGFloat = 140
        let gap:        CGFloat = 16
        
        let bubbleX = clamp(anchor.frame.midX,
                            min: bubbleW / 2 + 16,
                            max: screenSize.width - bubbleW / 2 - 16)
        
        let spaceBelow = screenSize.height - anchor.frame.maxY
        let spaceAbove = anchor.frame.minY
        var bubbleY: CGFloat
        
        if spaceBelow > estimatedH + gap * 2 {
            bubbleY = anchor.frame.maxY + gap + estimatedH / 2
        } else if spaceAbove > estimatedH + gap * 2 {
            bubbleY = anchor.frame.minY - gap - estimatedH / 2
        } else {
            bubbleY = screenSize.height / 2
        }
        
        bubbleY = clamp(bubbleY,
                        min: estimatedH / 2 + 16,
                        max: screenSize.height - estimatedH / 2 - 16)
        
        return VStack(alignment: .leading, spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(step.title)
                    .font(DSFont.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                Text(step.message)
                    .font(DSFont.subheadline)
                    .foregroundStyle(DSColor.Text.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            HStack(spacing: DSSpacing.sm) {
                DSProgressBar(progress: .constant(manager.progress),
                              style: .bar,
                              tintColor: DSColor.accent,
                              showPercentage: false,
                              animated: true)
                .frame(maxWidth: .infinity)
                
                Button { manager.skip(key: onboardingKey) } label: {
                    Text(L10n.CoachMark.skip)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Text.tertiary)
                }
                
                DSButton(title: manager.stepIndex == manager.steps.count - 1 ? L10n.CoachMark.gotIt : L10n.CoachMark.next,
                         style: .filled,
                         size: .small) {
                    manager.next(key: onboardingKey)
                }
            }
        }
        .padding(DSSpacing.lg)
        .frame(width: bubbleW)
        .background(DSColor.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 6)
        .position(x: bubbleX, y: bubbleY)
    }
    
    private func clamp(_ value: CGFloat,
                       min minVal: CGFloat,
                       max maxVal: CGFloat) -> CGFloat {
        min(max(value, minVal), maxVal)
    }
}

    // MARK: - View modifier
struct DSCoachMarkModifier: ViewModifier {
    let key: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
                DSCoachMarkOverlay(onboardingKey: key)
                    .zIndex(1000)
            }
            .onPreferenceChange(DSCoachMarkPreferenceKey.self) { anchors in
                DSCoachMarkManager.shared.anchors = anchors
            }
    }
}

extension View {
    func coachMarkOverlay(key: String) -> some View {
        modifier(DSCoachMarkModifier(key: key))
    }
}

#Preview {
    DSCoachMarkPreviewDemo()
}

private struct DSCoachMarkPreviewDemo: View {
    
    @State private var manager = DSCoachMarkManager.shared
    
    private let demoKey = "preview_demo"
    private let steps: [DSCoachMarkStep] = [
        DSCoachMarkStep(id: "tab_catalog",
                        title: "Components Catalog",
                        message: "Browse all available UI components organized by category."),
        DSCoachMarkStep(id: "tab_teams",
                        title: "Teams",
                        message: "Explore teams from the top European leagues."),
        DSCoachMarkStep(id: "tab_settings",
                        title: "Settings",
                        message: "Switch themes, languages and reset your preferences here.")
    ]
    
    var body: some View {
        VStack(spacing: DSSpacing.xl) {
            Spacer()
            
            HStack(spacing: DSSpacing.xl) {
                tabItem(id: "tab_catalog", icon: "square.grid.2x2", label: "Catalog")
                tabItem(id: "tab_teams",   icon: "shield",           label: "Teams")
                tabItem(id: "tab_settings",icon: "gearshape",        label: "Settings")
            }
            .padding(DSSpacing.lg)
            .background(DSColor.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
            
            Spacer()
            
            VStack(spacing: DSSpacing.sm) {
                DSButton(title: "Start Onboarding",
                         style: .filled,
                         icon: "play.circle",
                         isFullWidth: true) {
                    manager.reset(key: demoKey)
                    manager.start(steps: steps, key: demoKey)
                }
                DSButton(title: "Reset",
                         style: .outlined,
                         icon: "arrow.counterclockwise",
                         isFullWidth: true) {
                    manager.reset(key: demoKey)
                }
            }
        }
        .padding(DSSpacing.lg)
        .coachMarkOverlay(key: demoKey)
    }
    
    private func tabItem(id: String, icon: String, label: String) -> some View {
        VStack(spacing: DSSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(DSColor.accent)
            Text(label)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.secondary)
        }
        .coachMarkTarget(id: id)
    }
}
