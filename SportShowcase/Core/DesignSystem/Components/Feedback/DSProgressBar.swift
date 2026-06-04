import SwiftUI

enum DSProgressStyle {
    case bar
    case circle
    case barWithLabel
}

struct DSProgressBar: View {
    
    @Binding var progress: Double
    var style: DSProgressStyle   = .bar
    var tintColor: Color         = DSColor.accent
    var trackColor: Color        = DSColor.Text.tertiary.opacity(0.15)
    var showPercentage: Bool      = true
    var label: String?           = nil
    var animated: Bool           = true
    
    private var percentage: Int { Int(min(max(progress, 0), 1) * 100) }
    private var clampedProgress: Double { min(max(progress, 0), 1) }
    
    var body: some View {
        switch style {
            case .bar:          barProgress
            case .circle:       circleProgress
            case .barWithLabel: barWithLabelProgress
        }
    }
    
    // MARK: - Bar
    private var barProgress: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if showPercentage {
                HStack {
                    if let label {
                        Text(label)
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.secondary)
                    }
                    Spacer()
                    Text("\(percentage)%")
                        .font(DSFont.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(tintColor)
                        .monospacedDigit()
                        .animation(.easeInOut(duration: 0.1), value: percentage)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: DSRadius.full)
                        .fill(trackColor)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: DSRadius.full)
                        .fill(tintColor)
                        .frame(width: max(geo.size.width * clampedProgress, clampedProgress > 0 ? 8 : 0),
                               height: 8)
                        .animation(animated ? .spring(response: 0.4, dampingFraction: 0.8) : nil,
                                   value: clampedProgress)
                }
            }
            .frame(height: 8)
        }
    }
    
    // MARK: - Circle
    private var circleProgress: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(tintColor,
                        style: StrokeStyle(lineWidth: 8,
                                           lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(animated ? .spring(response: 0.5, dampingFraction: 0.8) : nil,
                           value: clampedProgress)
            
            VStack(spacing: 2) {
                Text("\(percentage)%")
                    .font(DSFont.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(DSColor.Text.primary)
                    .monospacedDigit()
                if let label {
                    Text(label)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Text.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .animation(.easeInOut(duration: 0.1), value: percentage)
        }
        .frame(width: 120, height: 120)
    }
    
    // MARK: - Bar with label
    private var barWithLabelProgress: some View {
        DSCard(style: .outlined, padding: DSSpacing.md) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                HStack {
                    if let label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(label)
                                .font(DSFont.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(DSColor.Text.primary)
                            Text(progressDescription)
                                .font(DSFont.caption)
                                .foregroundStyle(DSColor.Text.tertiary)
                        }
                    }
                    Spacer()
                    Text("\(percentage)%")
                        .font(DSFont.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(tintColor)
                        .monospacedDigit()
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: DSRadius.full)
                            .fill(trackColor)
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: DSRadius.full)
                            .fill(LinearGradient(colors: [tintColor, tintColor.opacity(0.7)],
                                                 startPoint: .leading,
                                                 endPoint: .trailing))
                            .frame(width: max(geo.size.width * clampedProgress, clampedProgress > 0 ? 10 : 0),
                                   height: 10)
                            .animation(animated ? .spring(response: 0.4, dampingFraction: 0.8) : nil,
                                       value: clampedProgress)
                    }
                }
                .frame(height: 10)
            }
        }
    }
    
    private var progressDescription: String {
        if percentage == 0    { return "Not started" }
        if percentage == 100  { return "Completed" }
        return "In progress..."
    }
}

// MARK: - Demo view with simulated download
struct DSProgressBarDemo: View {
    
    @State private var progress1: Double = 0
    @State private var progress2: Double = 0
    @State private var progress3: Double = 0
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: DSSpacing.xl) {
            DSProgressBar(progress: $progress1,
                          style: .bar,
                          tintColor: DSColor.accent,
                          label: "Downloading players...")
            
            HStack(spacing: DSSpacing.xl) {
                DSProgressBar(progress: $progress2,
                              style: .circle,
                              tintColor: DSColor.secondary,
                              label: "Sync")
                
                DSProgressBar(progress: $progress3,
                              style: .circle,
                              tintColor: DSColor.Semantic.success,
                              label: "Upload")
            }
            
            DSProgressBar(progress: $progress1,
                          style: .barWithLabel,
                          tintColor: DSColor.accent,
                          label: "Match data")
            
            DSButton(title: isRunning ? "Reset" : "Simulate Download",
                     style: .filled,
                     icon: isRunning ? "arrow.counterclockwise" : "arrow.down.circle",
                     isFullWidth: true) {
                if isRunning {
                    resetProgress()
                } else {
                    simulateDownload()
                }
            }
        }
        .padding(DSSpacing.lg)
    }
    
    private func simulateDownload() {
        isRunning = true
        progress1 = 0
        progress2 = 0
        progress3 = 0
        
        let totalSteps = 40
        for i in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                progress1 = Double(i) / Double(totalSteps)
                progress2 = Double(min(i, totalSteps - 5)) / Double(totalSteps)
                progress3 = Double(min(i + 5, totalSteps)) / Double(totalSteps)
                if i == totalSteps { isRunning = false }
            }
        }
    }
    
    private func resetProgress() {
        withAnimation(.spring(response: 0.4)) {
            progress1 = 0
            progress2 = 0
            progress3 = 0
            isRunning = false
        }
    }
}

#Preview {
    DSProgressBarDemo()
}
