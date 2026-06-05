import SwiftUI

enum DSLoaderStyle {
    case circular
    case linear
    case pulse
    case bounce
}

enum DSLoaderSize {
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
            case .small:  return 20
            case .medium: return 36
            case .large:  return 56
        }
    }
}

struct DSLoader: View {
    
    var style: DSLoaderStyle  = .circular
    var size: DSLoaderSize    = .medium
    var tintColor: Color      = DSColor.accent
    var label: String?        = nil
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            loaderContent
            if let label {
                Text(label)
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Text.secondary)
            }
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }
    
    // MARK: - Loader content
    @ViewBuilder
    private var loaderContent: some View {
        switch style {
            case .circular: circularLoader
            case .linear:   linearLoader
            case .pulse:    pulseLoader
            case .bounce:   bounceLoader
        }
    }
    
    // MARK: - Circular
    private var circularLoader: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(tintColor)
            .scaleEffect(size == .large ? 1.5 : size == .small ? 0.7 : 1.0)
            .frame(width: size.dimension, height: size.dimension)
    }
    
    // MARK: - Linear
    private var linearLoader: some View {
        ProgressView()
            .progressViewStyle(.linear)
            .tint(tintColor)
            .frame(width: size == .small ? 100 : size == .medium ? 160 : 220)
    }
    
    // MARK: - Pulse
    private var pulseLoader: some View {
        Circle()
            .fill(tintColor)
            .frame(width: size.dimension, height: size.dimension)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.4 : 1.0)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                       value: isAnimating)
    }
    
    // MARK: - Bounce
    private var bounceLoader: some View {
        HStack(spacing: DSSpacing.xs) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(tintColor)
                    .frame(width: size.dimension * 0.35,
                           height: size.dimension * 0.35)
                    .offset(y: isAnimating ? -size.dimension * 0.3 : 0)
                    .animation(.easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.15),
                               value: isAnimating)
            }
        }
        .frame(height: size.dimension)
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        HStack(spacing: DSSpacing.xl) {
            DSLoader(style: .circular, size: .small)
            DSLoader(style: .circular, size: .medium)
            DSLoader(style: .circular, size: .large)
        }
        
        DSLoader(style: .linear,
                 size: .medium,
                 tintColor: DSColor.secondary,
                 label: L10n.General.loading)
        
        HStack(spacing: DSSpacing.xl) {
            DSLoader(style: .pulse,
                     size: .medium,
                     tintColor: DSColor.accent)
            DSLoader(style: .bounce,
                     size: .medium,
                     tintColor: DSColor.secondary)
        }
    }
    .padding(DSSpacing.lg)
}
