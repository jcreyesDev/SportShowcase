import SwiftUI

enum DSDividerStyle {
    case solid
    case dashed
    case dotted
    case gradient
}

enum DSDividerOrientation {
    case horizontal
    case vertical
}

struct DSDivider: View {
    
    var style: DSDividerStyle          = .solid
    var orientation: DSDividerOrientation = .horizontal
    var color: Color                   = DSColor.Text.tertiary.opacity(0.3)
    var thickness: CGFloat             = 1
    var label: String?                 = nil
    
    var body: some View {
        if let label {
            labeledDivider(label: label)
        } else {
            plainDivider
        }
    }
    
    // MARK: - Plain
    @ViewBuilder
    private var plainDivider: some View {
        switch orientation {
            case .horizontal: horizontalDivider
            case .vertical:   verticalDivider
        }
    }
    
    private var horizontalDivider: some View {
        Group {
            switch style {
                case .solid:
                    Rectangle()
                        .fill(color)
                        .frame(height: thickness)
                    
                case .dashed:
                    Line()
                        .stroke(color,
                                style: StrokeStyle(lineWidth: thickness,
                                                   dash: [6, 4]))
                        .frame(height: thickness)
                    
                case .dotted:
                    Line()
                        .stroke(color,
                                style: StrokeStyle(lineWidth: thickness,
                                                   lineCap: .round,
                                                   dash: [1, 5]))
                        .frame(height: thickness)
                    
                case .gradient:
                    LinearGradient(colors: [.clear, color, color, .clear],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(height: thickness)
            }
        }
    }
    
    private var verticalDivider: some View {
        Group {
            switch style {
                case .solid:
                    Rectangle()
                        .fill(color)
                        .frame(width: thickness)
                    
                case .dashed:
                    VerticalLine()
                        .stroke(color,
                                style: StrokeStyle(lineWidth: thickness,
                                                   dash: [6, 4]))
                        .frame(width: thickness)
                    
                case .dotted:
                    VerticalLine()
                        .stroke(color,
                                style: StrokeStyle(lineWidth: thickness,
                                                   lineCap: .round,
                                                   dash: [1, 5]))
                        .frame(width: thickness)
                    
                case .gradient:
                    LinearGradient(colors: [.clear, color, color, .clear],
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .frame(width: thickness)
            }
        }
    }
    
    // MARK: - Labeled
    private func labeledDivider(label: String) -> some View {
        HStack(spacing: DSSpacing.md) {
            Rectangle()
                .fill(color)
                .frame(height: thickness)
            
            Text(label)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
                .lineLimit(1)
                .fixedSize()
            
            Rectangle()
                .fill(color)
                .frame(height: thickness)
        }
    }
}

// MARK: - Shape helpers
private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

private struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        DSDivider(style: .solid)
        DSDivider(style: .dashed)
        DSDivider(style: .dotted)
        DSDivider(style: .gradient, color: DSColor.accent)
        DSDivider(style: .solid, label: "OR")
        DSDivider(style: .gradient,
                  color: DSColor.secondary,
                  label: "Top European Leagues")
        
        HStack(spacing: DSSpacing.lg) {
            Text("Left")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Text.primary)
            DSDivider(style: .solid, orientation: .vertical)
                .frame(height: 24)
            Text("Center")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Text.primary)
            DSDivider(style: .dashed, orientation: .vertical)
                .frame(height: 24)
            Text("Right")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Text.primary)
        }
    }
    .padding(DSSpacing.lg)
}
