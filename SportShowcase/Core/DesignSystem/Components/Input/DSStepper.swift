import SwiftUI

enum DSStepperStyle {
    case standard
    case compact
    case card
}

struct DSStepper: View {
    
    let label: String
    @Binding var value: Double
    var minimum: Double          = 0
    var maximum: Double          = 100
    var step: Double             = 1
    var unit: String?            = nil
    var style: DSStepperStyle    = .standard
    var tintColor: Color         = DSColor.accent
    var isDisabled: Bool         = false
    var formatValue: ((Double) -> String)? = nil
    
    private var displayValue: String {
        if let format = formatValue { return format(value) }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))\(unit.map { " \($0)" } ?? "")"
        }
        return String(format: "%.1f\(unit.map { " \($0)" } ?? "")", value)
    }
    
    var body: some View {
        switch style {
            case .standard: standardStepper
            case .compact:  compactStepper
            case .card:     cardStepper
        }
    }
    
    // MARK: - Standard
    private var standardStepper: some View {
        HStack(spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DSFont.body)
                    .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
                Text(displayValue)
                    .font(DSFont.footnote)
                    .foregroundStyle(tintColor)
                    .animation(.easeInOut(duration: 0.15), value: value)
            }
            Spacer()
            stepperControls
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Compact
    private var compactStepper: some View {
        HStack(spacing: DSSpacing.sm) {
            stepButton(icon: "minus", action: decrement)
            Text(displayValue)
                .font(DSFont.headline)
                .fontWeight(.medium)
                .foregroundStyle(DSColor.Text.primary)
                .monospacedDigit()
                .frame(minWidth: 48)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.15), value: value)
            stepButton(icon: "plus", action: increment)
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Card
    private var cardStepper: some View {
        DSCard(style: .outlined, padding: DSSpacing.md) {
            VStack(spacing: DSSpacing.md) {
                Text(label)
                    .font(DSFont.subheadline)
                    .foregroundStyle(DSColor.Text.secondary)
                Text(displayValue)
                    .font(DSFont.title1)
                    .fontWeight(.bold)
                    .foregroundStyle(tintColor)
                    .monospacedDigit()
                    .animation(.spring(response: 0.3), value: value)
                stepperControls
            }
            .frame(maxWidth: .infinity)
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Stepper controls
    private var stepperControls: some View {
        HStack(spacing: DSSpacing.xs) {
            stepButton(icon: "minus", action: decrement)
            stepButton(icon: "plus",  action: increment)
        }
    }
    
    // MARK: - Step button
    private func stepButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(tintColor)
                .frame(width: 36, height: 36)
                .background(tintColor.opacity(0.12))
                .clipShape(Circle())
        }
        .disabled(isDisabled)
    }
    
    // MARK: - Actions
    private func increment() {
        guard value < maximum else { return }
        withAnimation(.spring(response: 0.2)) {
            value = min(value + step, maximum)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func decrement() {
        guard value > minimum else { return }
        withAnimation(.spring(response: 0.2)) {
            value = max(value - step, minimum)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview {
    @Previewable @State var value1: Double = 5
    @Previewable @State var value2: Double = 90
    @Previewable @State var value3: Double = 11
    
    VStack(spacing: DSSpacing.xl) {
        DSStepper(label: "Players on field",
                  value: $value1,
                  minimum: 1,
                  maximum: 11,
                  step: 1,
                  style: .standard,
                  tintColor: DSColor.accent)
        
        DSStepper(label: "Match minutes",
                  value: $value2,
                  minimum: 0,
                  maximum: 120,
                  step: 1,
                  unit: "min",
                  style: .compact,
                  tintColor: DSColor.secondary)
        
        DSStepper(label: "Jersey number",
                  value: $value3,
                  minimum: 1,
                  maximum: 99,
                  step: 1,
                  style: .card,
                  tintColor: DSColor.accent)
    }
    .padding(DSSpacing.lg)
}
