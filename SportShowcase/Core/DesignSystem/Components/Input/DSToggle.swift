import SwiftUI

enum DSToggleStyle {
    case standard
    case custom
    case labeled
}

struct DSToggle: View {
    
    let label: String
    @Binding var isOn: Bool
    var subtitle: String?        = nil
    var icon: String?            = nil
    var style: DSToggleStyle     = .standard
    var tintColor: Color         = DSColor.accent
    var isDisabled: Bool         = false
    
    var body: some View {
        switch style {
            case .standard:  standardToggle
            case .custom:    customToggle
            case .labeled:   labeledToggle
        }
    }
    
    // MARK: - Standard
    private var standardToggle: some View {
        HStack(spacing: DSSpacing.md) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isOn ? tintColor : DSColor.Text.tertiary)
                    .animation(.easeInOut(duration: 0.2), value: isOn)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DSFont.body)
                    .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
                if let subtitle {
                    Text(subtitle)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Text.tertiary)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(tintColor)
                .disabled(isDisabled)
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Custom
    private var customToggle: some View {
        HStack(spacing: DSSpacing.md) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isOn ? tintColor : DSColor.Text.tertiary)
            }
            Text(label)
                .font(DSFont.body)
                .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
            Spacer()
            customThumb
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .onTapGesture {
            guard !isDisabled else { return }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    private var customThumb: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .fill(isOn ? tintColor : DSColor.Text.tertiary.opacity(0.3))
                .frame(width: 52, height: 30)
            
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 1)
                .padding(3)
        }
    }
    
    // MARK: - Labeled
    private var labeledToggle: some View {
        HStack(spacing: 0) {
            Button {
                guard !isDisabled else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn = false
                }
            } label: {
                Text(L10n.Settings.themeDark)
                    .font(DSFont.subheadline)
                    .fontWeight(isOn ? .regular : .medium)
                    .foregroundStyle(isOn ? DSColor.Text.tertiary : DSColor.Text.onAccent)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(isOn ? Color.clear : tintColor)
                    .clipShape(Capsule())
            }
            
            Button {
                guard !isDisabled else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn = true
                }
            } label: {
                Text(L10n.Settings.themeLight)
                    .font(DSFont.subheadline)
                    .fontWeight(isOn ? .medium : .regular)
                    .foregroundStyle(isOn ? DSColor.Text.onAccent : DSColor.Text.tertiary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(isOn ? tintColor : Color.clear)
                    .clipShape(Capsule())
            }
        }
        .padding(3)
        .background(DSColor.Background.secondary)
        .clipShape(Capsule())
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview("Standard") {
    @Previewable @State var toggle1 = true
    @Previewable @State var toggle2 = false
    @Previewable @State var toggle3 = true
    
    VStack(spacing: DSSpacing.lg) {
        DSToggle(label: "Notifications",
                 isOn: $toggle1,
                 subtitle: "Receive match alerts",
                 icon: "bell",
                 style: .standard)
        
        DSToggle(label: "Dark Mode",
                 isOn: $toggle2,
                 icon: "moon",
                 style: .standard,
                 tintColor: DSColor.secondary)
        
        DSToggle(label: "Disabled Toggle",
                 isOn: $toggle3,
                 style: .standard,
                 isDisabled: true)
    }
    .padding(DSSpacing.lg)
}

#Preview("Custom + Labeled") {
    @Previewable @State var custom = true
    @Previewable @State var labeled = false
    
    VStack(spacing: DSSpacing.xl) {
        DSToggle(label: "Custom Toggle",
                 isOn: $custom,
                 icon: "star",
                 style: .custom,
                 tintColor: DSColor.accent)
        
        DSToggle(label: "Theme",
                 isOn: $labeled,
                 style: .labeled)
    }
    .padding(DSSpacing.lg)
}
