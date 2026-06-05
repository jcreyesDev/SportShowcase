import SwiftUI

struct InputShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct InputComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        InputComponent(id: 0, name: "Text Field"),
        InputComponent(id: 1, name: "Search Bar"),
        InputComponent(id: 2, name: "Toggle"),
        InputComponent(id: 3, name: "Stepper"),
        InputComponent(id: 4, name: "Slider"),
        InputComponent(id: 5, name: "Picker")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
                // Component name + page indicator
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
            
                // Swipeable content
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
        .navigationTitle("Inputs")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: TextFieldPlayground()
            case 1: SearchBarPlayground()
            case 2: TogglePlayground()
            case 3: StepperPlayground()
            case 4: SliderPlayground()
            case 5: PickerPlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - TextField Playground
private struct TextFieldPlayground: View {
    
    @State private var text      = ""
    @State private var styleIdx  = 0
    @State private var stateIdx  = 0
    @State private var showIcon  = false
    
    private let styles: [DSTextFieldStyle] = [.outlined, .filled, .underlined]
    private let styleNames = ["Outlined", "Filled", "Underlined"]
    private let states: [DSTextFieldState] = [.normal, .success("Valid"), .error("Required"), .disabled]
    private let stateNames = ["Normal", "Success", "Error", "Disabled"]
    
    private let info = ComponentInfo(
        name: "Text Field",
        description: "Text fields allow users to enter and edit text. They appear in forms, dialogs, and search screens.",
        usageScenarios: [
            UsageScenario(icon: "envelope", title: "Forms",
                          description: "Use in login, registration, or data entry forms."),
            UsageScenario(icon: "lock", title: "Secure input",
                          description: "Use the password type for sensitive data.")
        ],
        configurability: "3 styles, 5 input types, 5 states, optional icon and helper text.",
        bestPractices: [
            "Always show a clear label above the field.",
            "Provide inline validation with success/error states.",
            "Use the correct keyboard type for the input."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSTextField(label: "Label",
                        text: $text,
                        placeholder: "Placeholder...",
                        style: styles[styleIdx],
                        state: states[stateIdx],
                        icon: showIcon ? "person" : nil)
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactControlRow(title: "Style",
                              options: styleNames,
                              selected: $styleIdx)
            CompactControlRow(title: "State",
                              options: stateNames,
                              selected: $stateIdx)
            CompactToggleRow(title: "Show icon", isOn: $showIcon)
        }
    }
}

    // MARK: - SearchBar Playground
private struct SearchBarPlayground: View {
    
    @State private var text = ""
    
    private let info = ComponentInfo(
        name: "Search Bar",
        description: "Search bars allow users to search and filter content. They appear at the top of content lists.",
        usageScenarios: [
            UsageScenario(icon: "magnifyingglass", title: "Content filtering",
                          description: "Filter lists of teams, players, or matches in real time.")
        ],
        configurability: "Custom placeholder, submit and cancel callbacks, animated cancel button.",
        bestPractices: [
            "Place at the top of scrollable content.",
            "Show results instantly as the user types.",
            "Show an empty state when no results match."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSSearchBar(text: $text,
                        placeholder: "Search teams, players...")
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactValueRow(title: "Current value",
                            value: text.isEmpty ? "—" : text)
        }
    }
}

    // MARK: - Toggle Playground
private struct TogglePlayground: View {
    
    @State private var isOn     = true
    @State private var styleIdx = 0
    @State private var showIcon = true
    
    private let styles: [DSToggleStyle] = [.standard, .custom, .labeled]
    private let styleNames = ["Standard", "Custom", "Labeled"]
    
    private let info = ComponentInfo(
        name: "Toggle",
        description: "Toggles allow users to switch between two mutually exclusive states — on and off.",
        usageScenarios: [
            UsageScenario(icon: "bell", title: "Settings",
                          description: "Enable or disable features like notifications or dark mode.")
        ],
        configurability: "3 styles, optional icon, custom tint, disabled state.",
        bestPractices: [
            "Use standard style for settings lists.",
            "Always provide a clear label describing what the toggle controls."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSToggle(label: "Enable notifications",
                     isOn: $isOn,
                     subtitle: "Receive match and player alerts",
                     icon: showIcon ? "bell" : nil,
                     style: styles[styleIdx],
                     tintColor: DSColor.accent)
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactControlRow(title: "Style",
                              options: styleNames,
                              selected: $styleIdx)
            CompactToggleRow(title: "Show icon", isOn: $showIcon)
        }
    }
}

    // MARK: - Stepper Playground
private struct StepperPlayground: View {
    
    @State private var value: Double = 11
    @State private var styleIdx = 0
    
    private let styles: [DSStepperStyle] = [.standard, .compact, .card]
    private let styleNames = ["Standard", "Compact", "Card"]
    
    private let info = ComponentInfo(
        name: "Stepper",
        description: "Steppers allow users to increment or decrement a numeric value within a defined range.",
        usageScenarios: [
            UsageScenario(icon: "number", title: "Numeric input",
                          description: "Set jersey numbers, match minutes, or player counts.")
        ],
        configurability: "3 styles, min/max/step values, optional unit label.",
        bestPractices: [
            "Always define a min and max to prevent invalid values.",
            "Use compact style in tight spaces like table rows."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSStepper(label: "Players on field",
                      value: $value,
                      minimum: 1,
                      maximum: 11,
                      step: 1,
                      style: styles[styleIdx],
                      tintColor: DSColor.accent)
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactControlRow(title: "Style",
                              options: styleNames,
                              selected: $styleIdx)
            CompactValueRow(title: "Current value",
                            value: "\(Int(value))")
        }
    }
}

    // MARK: - Slider Playground
private struct SliderPlayground: View {
    
    @State private var value: Double = 75
    @State private var styleIdx  = 0
    @State private var showValue = true
    @State private var showMinMax = true
    
    private let styles: [DSSliderStyle] = [.standard, .stepped]
    private let styleNames = ["Standard", "Stepped"]
    
    private let info = ComponentInfo(
        name: "Slider",
        description: "Sliders allow users to select a value from a continuous or stepped range by dragging a thumb.",
        usageScenarios: [
            UsageScenario(icon: "speedometer", title: "Player attributes",
                          description: "Display or adjust player stats like speed or accuracy.")
        ],
        configurability: "2 styles, optional step, unit label, min/max and value display.",
        bestPractices: [
            "Show the current value in real time as the user drags.",
            "Always show min/max labels to give context to the range."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSSlider(label: "Player speed",
                     value: $value,
                     minimum: 0,
                     maximum: 100,
                     unit: "%",
                     style: styles[styleIdx],
                     tintColor: DSColor.accent,
                     showValue: showValue,
                     showMinMax: showMinMax)
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactControlRow(title: "Style",
                              options: styleNames,
                              selected: $styleIdx)
            CompactToggleRow(title: "Show value", isOn: $showValue)
            CompactToggleRow(title: "Show min/max", isOn: $showMinMax)
        }
    }
}

    // MARK: - Picker Playground
private struct PickerPlayground: View {
    
    @State private var selected  = "Forward"
    @State private var styleIdx  = 0
    @State private var selectedChips: Set<String> = ["Forward"]
    
    private let options = ["Forward", "Midfielder", "Defender", "Goalkeeper"]
    private let styles: [DSPickerStyle] = [.segmented, .menu, .wheel, .chip]
    private let styleNames = ["Segmented", "Menu", "Wheel", "Chip"]
    
    private let info = ComponentInfo(
        name: "Picker",
        description: "Pickers allow users to select one option from a set. Choose the style based on the number of options and context.",
        usageScenarios: [
            UsageScenario(icon: "list.bullet", title: "Option selection",
                          description: "Select player positions, leagues, or match statuses.")
        ],
        configurability: "4 styles (segmented, menu, wheel, chip), custom formatting.",
        bestPractices: [
            "Use segmented for 2-4 options that are always visible.",
            "Use menu for 5+ options to save screen space."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            Group {
                if styles[styleIdx] == .chip {
                    DSChipGroup(chips: options,
                                selected: $selectedChips,
                                style: .filled,
                                tintColor: DSColor.accent)
                } else {
                    DSPicker(label: "Position",
                             selection: $selected,
                             options: options,
                             style: styles[styleIdx])
                }
            }
            .padding(.horizontal, DSSpacing.xs)
        } controls: {
            CompactControlRow(title: "Style",
                              options: styleNames,
                              selected: $styleIdx)
        }
    }
}

    // MARK: - Conformances
extension DSTextFieldState: Equatable, Hashable {
    public static func == (lhs: DSTextFieldState, rhs: DSTextFieldState) -> Bool {
        switch (lhs, rhs) {
            case (.normal, .normal), (.focused, .focused), (.disabled, .disabled): return true
            case (.success(let a), .success(let b)): return a == b
            case (.error(let a), .error(let b)):     return a == b
            default: return false
        }
    }
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .normal:         hasher.combine(0)
            case .focused:        hasher.combine(1)
            case .success(let m): hasher.combine(2); hasher.combine(m)
            case .error(let m):   hasher.combine(3); hasher.combine(m)
            case .disabled:       hasher.combine(4)
        }
    }
}

extension DSTextFieldStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .outlined:   return "Outlined"
            case .filled:     return "Filled"
            case .underlined: return "Underlined"
        }
    }
}

extension DSToggleStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .standard: return "Standard"
            case .custom:   return "Custom"
            case .labeled:  return "Labeled"
        }
    }
}

extension DSStepperStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .standard: return "Standard"
            case .compact:  return "Compact"
            case .card:     return "Card"
        }
    }
}

extension DSSliderStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .standard: return "Standard"
            case .ranged:   return "Ranged"
            case .stepped:  return "Stepped"
        }
    }
}

extension DSPickerStyle: CustomStringConvertible, Hashable {
    public var description: String {
        switch self {
            case .segmented: return "Segmented"
            case .menu:      return "Menu"
            case .wheel:     return "Wheel"
            case .chip:      return "Chip"
        }
    }
}

#Preview {
    NavigationStack {
        InputShowcaseView()
    }
}
