import SwiftUI

enum DSSegmentedStyle {
    case standard
    case pill
    case underline
}

struct DSSegmentedControl<T: Hashable & CustomStringConvertible>: View {
    
    @Binding var selection: T
    let options: [T]
    var style: DSSegmentedStyle  = .pill
    var tintColor: Color         = DSColor.accent
    var fullWidth: Bool          = true
    var formatOption: ((T) -> String)? = nil
    
    private func displayText(_ option: T) -> String {
        formatOption?(option) ?? option.description
    }
    
    var body: some View {
        switch style {
            case .standard:  standardControl
            case .pill:      pillControl
            case .underline: underlineControl
        }
    }
    
    // MARK: - Standard
    private var standardControl: some View {
        Picker("", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(displayText(option)).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .tint(tintColor)
    }
    
    // MARK: - Pill
    private var pillControl: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { option in
                let isSelected = selection == option
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Text(displayText(option))
                        .font(DSFont.subheadline)
                        .fontWeight(isSelected ? .medium : .regular)
                        .foregroundStyle(isSelected ? DSColor.Text.onAccent : DSColor.Text.secondary)
                        .frame(maxWidth: fullWidth ? .infinity : nil)
                        .padding(.horizontal, fullWidth ? 0 : DSSpacing.lg)
                        .padding(.vertical, DSSpacing.sm)
                        .background(isSelected ? tintColor : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(DSColor.Background.secondary)
        .clipShape(Capsule())
    }
    
    // MARK: - Underline
    private var underlineControl: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selection == option
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection = option
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        VStack(spacing: DSSpacing.sm) {
                            Text(displayText(option))
                                .font(DSFont.subheadline)
                                .fontWeight(isSelected ? .medium : .regular)
                                .foregroundStyle(isSelected ? tintColor : DSColor.Text.tertiary)
                                .frame(maxWidth: fullWidth ? .infinity : nil)
                                .padding(.horizontal, fullWidth ? 0 : DSSpacing.lg)
                                .padding(.top, DSSpacing.sm)
                            
                            Rectangle()
                                .fill(isSelected ? tintColor : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            DSDivider()
        }
    }
}

#Preview {
    @Previewable @State var selected1 = "All"
    @Previewable @State var selected2 = "Matches"
    @Previewable @State var selected3 = "La Liga"
    
    VStack(spacing: DSSpacing.xl) {
        DSSegmentedControl(selection: $selected1,
                           options: ["All", "Live", "Upcoming"],
                           style: .pill)
        
        DSSegmentedControl(selection: $selected2,
                           options: ["Matches", "Players", "Teams"],
                           style: .underline)
        
        DSSegmentedControl(selection: $selected3,
                           options: ["La Liga", "Premier", "Serie A"],
                           style: .standard)
    }
    .padding(DSSpacing.lg)
}
