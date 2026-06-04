import SwiftUI

enum DSPickerStyle {
    case segmented
    case menu
    case wheel
    case chip
}

struct DSPicker<T: Hashable & CustomStringConvertible>: View {
    
    let label: String
    @Binding var selection: T
    let options: [T]
    var style: DSPickerStyle     = .segmented
    var tintColor: Color         = DSColor.accent
    var isDisabled: Bool         = false
    var formatOption: ((T) -> String)? = nil
    
    private func displayText(_ option: T) -> String {
        formatOption?(option) ?? option.description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            if !label.isEmpty {
                Text(label)
                    .font(DSFont.subheadline)
                    .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
            }
            pickerContent
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Picker content
    @ViewBuilder
    private var pickerContent: some View {
        switch style {
            case .segmented: segmentedPicker
            case .menu:      menuPicker
            case .wheel:     wheelPicker
            case .chip:      chipPicker
        }
    }
    
    // MARK: - Segmented
    private var segmentedPicker: some View {
        Picker(label, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(displayText(option)).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .tint(tintColor)
        .disabled(isDisabled)
    }
    
    // MARK: - Menu
    private var menuPicker: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = option
                    }
                } label: {
                    HStack {
                        Text(displayText(option))
                        if selection == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(displayText(selection))
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Text.primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 13))
                    .foregroundStyle(DSColor.Text.tertiary)
            }
            .padding(.horizontal, DSSpacing.md)
            .frame(height: 48)
            .background(DSColor.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.md)
                .strokeBorder(tintColor.opacity(0.3), lineWidth: 1))
        }
        .disabled(isDisabled)
    }
    
    // MARK: - Wheel
    private var wheelPicker: some View {
        Picker(label, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(displayText(option)).tag(option)
            }
        }
        .pickerStyle(.wheel)
        .tint(tintColor)
        .disabled(isDisabled)
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
    }
    
    // MARK: - Chip
    private var chipPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSSpacing.sm) {
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
                            .foregroundStyle(isSelected ? DSColor.Text.onAccent : DSColor.Text.primary)
                            .padding(.horizontal, DSSpacing.md)
                            .padding(.vertical, DSSpacing.sm)
                            .background(isSelected ? tintColor : DSColor.Background.secondary)
                            .clipShape(Capsule())
                            .overlay(Capsule()
                                .strokeBorder(isSelected ? Color.clear : DSColor.Text.tertiary.opacity(0.3),
                                              lineWidth: 1))
                            .scaleEffect(isSelected ? 1.03 : 1.0)
                    }
                    .disabled(isDisabled)
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

#Preview {
    @Previewable @State var position = "Forward"
    @Previewable @State var league   = "Premier League"
    @Previewable @State var rating   = "5"
    
    let positions    = ["Forward", "Midfielder", "Defender", "Goalkeeper"]
    let leagues      = ["Premier League", "La Liga", "Serie A", "Bundesliga", "Ligue 1"]
    let ratings      = ["1", "2", "3", "4", "5"]
    
    VStack(spacing: DSSpacing.xl) {
        DSPicker(label: "Position",
                 selection: $position,
                 options: positions,
                 style: .segmented)
        
        DSPicker(label: "League",
                 selection: $league,
                 options: leagues,
                 style: .chip,
                 tintColor: DSColor.accent)
        
        DSPicker(label: "Rating",
                 selection: $rating,
                 options: ratings,
                 style: .menu,
                 tintColor: DSColor.secondary)
    }
    .padding(DSSpacing.lg)
}
