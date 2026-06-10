import SwiftUI

    // MARK: - Usage scenario model
struct UsageScenario {
    let icon: String
    let title: String
    let description: String
}

    // MARK: - Component info model
struct ComponentInfo {
    let name: String
    let description: String
    let usageScenarios: [UsageScenario]
    let configurability: String
    let bestPractices: [String]
}

    // MARK: - Playground view
struct ComponentPlaygroundView<Preview: View, Controls: View>: View {
    
    let info: ComponentInfo
    @ViewBuilder let preview: () -> Preview
    @ViewBuilder let controls: () -> Controls
    
    @State private var showInfo = false
    
    private let onboardingKey = "playground_onboarding"
    
    private let onboardingSteps: [DSCoachMarkStep] = [
        DSCoachMarkStep(id: "cm_pager",
                        title: L10n.CoachMark.swipeTitle,
                        message: L10n.CoachMark.swipeMessage),
        DSCoachMarkStep(id: "cm_preview",
                        title: L10n.CoachMark.livePreviewTitle,
                        message: L10n.CoachMark.livePreviewMessage),
        DSCoachMarkStep(id: "cm_config",
                        title: L10n.CoachMark.configTitle,
                        message: L10n.CoachMark.configMessage),
        DSCoachMarkStep(id: "cm_about",
                        title: L10n.CoachMark.aboutTitle,
                        message: L10n.CoachMark.aboutMessage)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                previewArea
                    .background(anchorBackground(id: "cm_preview"))
                controlsSection
                    .background(anchorBackground(id: "cm_config"))
                infoSection
                    .background(anchorBackground(id: "cm_about"))
            }
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.lg)
        }
        .navigationTitle(info.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(DSColor.Background.primary)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                DSCoachMarkManager.shared.start(steps: onboardingSteps,
                                                key: onboardingKey)
            }
        }
    }
    
    private func anchorBackground(id: String) -> some View {
        GeometryReader { geo in
            let topInset = (UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first?.safeAreaInsets.top ?? 0)
            
            Color.clear.preference(
                key: DSCoachMarkPreferenceKey.self,
                value: [DSCoachMarkAnchor(id: id,
                                          frame: geo.frame(in: .global)
                    .offsetBy(dx: 0, dy: -topInset))])
        }
    }
    
        // MARK: - Preview area
    private var previewArea: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L10n.Playground.preview)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DSColor.accent)
                    .textCase(.uppercase)
                    .tracking(0.8)
                Spacer()
                DSBadge(title: info.name, style: .accent)
            }
            .padding(.horizontal, DSSpacing.lg)
            .padding(.top, DSSpacing.md)
            .padding(.bottom, DSSpacing.sm)
            
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.lg)
                    .fill(DSColor.Text.tertiary.opacity(0.08))
                
                RoundedRectangle(cornerRadius: DSRadius.lg)
                    .strokeBorder(DSColor.accent.opacity(0.2), lineWidth: 1)
                
                VStack(spacing: DSSpacing.sm) {
                    preview()
                        .padding(DSSpacing.lg)
                }
                .clipped()
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.bottom, DSSpacing.md)
            .frame(minHeight: 160)
            
            Text(L10n.Playground.interact)
                .font(.system(size: 11))
                .foregroundStyle(DSColor.Text.tertiary)
                .padding(.bottom, DSSpacing.md)
        }
        .background(DSColor.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.xl)
            .strokeBorder(DSColor.Text.tertiary.opacity(0.1), lineWidth: 0.5))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
        // MARK: - Controls section
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack(spacing: DSSpacing.xs) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 10))
                    .foregroundStyle(DSColor.accent)
                Text(L10n.Playground.configuration)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DSColor.Text.tertiary)
                    .textCase(.uppercase)
                    .tracking(0.8)
            }
            .padding(.horizontal, DSSpacing.sm)
            
            VStack(alignment: .leading, spacing: 0) {
                controls()
            }
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.lg)
                .strokeBorder(DSColor.Text.tertiary.opacity(0.1), lineWidth: 0.5))
        }
    }
    
        // MARK: - Info section
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack(spacing: DSSpacing.xs) {
                Image(systemName: "info.circle")
                    .font(.system(size: 10))
                    .foregroundStyle(DSColor.accent)
                Text(L10n.Playground.about)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DSColor.Text.tertiary)
                    .textCase(.uppercase)
                    .tracking(0.8)
            }
            .padding(.horizontal, DSSpacing.sm)
            
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showInfo.toggle()
                    }
                } label: {
                    HStack(alignment: .top, spacing: DSSpacing.sm) {
                        Text(info.description)
                            .font(.system(size: 12))
                            .foregroundStyle(DSColor.Text.secondary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Image(systemName: showInfo ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(DSColor.Text.tertiary)
                            .padding(.top, 2)
                    }
                    .padding(DSSpacing.md)
                }
                .buttonStyle(.plain)
                
                if showInfo {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        DSDivider()
                            .padding(.horizontal, DSSpacing.md)
                        
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text(L10n.Playground.whenToUse)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(DSColor.Text.tertiary)
                                .textCase(.uppercase)
                                .tracking(0.4)
                                .padding(.horizontal, DSSpacing.md)
                            
                            ForEach(info.usageScenarios, id: \.title) { scenario in
                                HStack(alignment: .top, spacing: DSSpacing.sm) {
                                    Image(systemName: scenario.icon)
                                        .font(.system(size: 12))
                                        .foregroundStyle(DSColor.accent)
                                        .frame(width: 18)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(scenario.title)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(DSColor.Text.primary)
                                        Text(scenario.description)
                                            .font(.system(size: 11))
                                            .foregroundStyle(DSColor.Text.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding(.horizontal, DSSpacing.md)
                            }
                        }
                        
                        DSDivider()
                            .padding(.horizontal, DSSpacing.md)
                        
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text(L10n.Playground.bestPractices)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(DSColor.Text.tertiary)
                                .textCase(.uppercase)
                                .tracking(0.4)
                                .padding(.horizontal, DSSpacing.md)
                            
                            ForEach(info.bestPractices, id: \.self) { practice in
                                HStack(alignment: .top, spacing: DSSpacing.sm) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(DSColor.Semantic.success)
                                    Text(practice)
                                        .font(.system(size: 11))
                                        .foregroundStyle(DSColor.Text.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal, DSSpacing.md)
                            }
                        }
                        .padding(.bottom, DSSpacing.md)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.lg)
                .strokeBorder(DSColor.Text.tertiary.opacity(0.1), lineWidth: 0.5))
        }
    }
}

    // MARK: - Control row helper
struct ControlRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(DSColor.Text.tertiary)
                .textCase(.uppercase)
                .tracking(0.4)
            content()
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        DSDivider()
            .padding(.horizontal, DSSpacing.md)
    }
}
