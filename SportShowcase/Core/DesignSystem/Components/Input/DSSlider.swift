import SwiftUI

enum DSSliderStyle {
    case standard
    case ranged
    case stepped
}

struct DSSlider: View {
    
    let label: String
    @Binding var value: Double
    var minimum: Double          = 0
    var maximum: Double          = 100
    var step: Double?            = nil
    var unit: String?            = nil
    var style: DSSliderStyle     = .standard
    var tintColor: Color         = DSColor.accent
    var showValue: Bool          = true
    var showMinMax: Bool         = true
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
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            headerRow
            sliderContent
            if showMinMax { minMaxRow }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Header
    private var headerRow: some View {
        HStack {
            Text(label)
                .font(DSFont.subheadline)
                .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
            Spacer()
            if showValue {
                Text(displayValue)
                    .font(DSFont.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(tintColor)
                    .monospacedDigit()
                    .animation(.easeInOut(duration: 0.1), value: value)
            }
        }
    }
    
    // MARK: - Slider content
    @ViewBuilder
    private var sliderContent: some View {
        switch style {
            case .standard, .ranged:
                standardSlider
            case .stepped:
                steppedSlider
        }
    }
    
    private var standardSlider: some View {
        Slider(value: $value,
               in: minimum...maximum,
               step: step ?? (maximum - minimum) / 100) {
            Text(label)
        } minimumValueLabel: {
            EmptyView()
        } maximumValueLabel: {
            EmptyView()
        }
        .tint(tintColor)
        .disabled(isDisabled)
    }
    
    private var steppedSlider: some View {
        VStack(spacing: DSSpacing.xs) {
            Slider(value: $value,
                   in: minimum...maximum,
                   step: step ?? 1) {
                Text(label)
            }
                   .tint(tintColor)
                   .disabled(isDisabled)
            
            // Step indicators
            if let step {
                HStack {
                    let steps = Int((maximum - minimum) / step)
                    ForEach(0...min(steps, 10), id: \.self) { i in
                        let stepValue = minimum + Double(i) * step
                        VStack(spacing: 2) {
                            Rectangle()
                                .fill(stepValue <= value ? tintColor : DSColor.Text.tertiary.opacity(0.3))
                                .frame(width: 1, height: 6)
                            if i == 0 || i == steps || i == steps / 2 {
                                Text("\(Int(stepValue))")
                                    .font(.system(size: 9))
                                    .foregroundStyle(DSColor.Text.tertiary)
                            }
                        }
                        if i < min(steps, 10) { Spacer() }
                    }
                }
            }
        }
    }
    
    // MARK: - Min/Max row
    private var minMaxRow: some View {
        HStack {
            Text("\(Int(minimum))\(unit.map { " \($0)" } ?? "")")
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
            Spacer()
            Text("\(Int(maximum))\(unit.map { " \($0)" } ?? "")")
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
        }
    }
}

#Preview {
    @Previewable @State var speed: Double   = 75
    @Previewable @State var rating: Double  = 3
    @Previewable @State var minutes: Double = 45
    
    VStack(spacing: DSSpacing.xl) {
        DSSlider(label: "Player speed",
                 value: $speed,
                 minimum: 0,
                 maximum: 100,
                 unit: "%",
                 style: .standard,
                 tintColor: DSColor.accent)
        
        DSSlider(label: "Match rating",
                 value: $rating,
                 minimum: 1,
                 maximum: 5,
                 step: 1,
                 style: .stepped,
                 tintColor: DSColor.secondary,
                 formatValue: { "★ \(Int($0))" })
        
        DSSlider(label: "Minutes played",
                 value: $minutes,
                 minimum: 0,
                 maximum: 90,
                 unit: "min",
                 style: .standard,
                 tintColor: DSColor.Semantic.success,
                 isDisabled: false)
    }
    .padding(DSSpacing.lg)
}
