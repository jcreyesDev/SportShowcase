import SwiftUI

struct DSSlideToConfirmButton: View {
    
    let title: String
    var subtitle: String?        = nil
    var icon: String             = "chevron.right.2"
    var confirmedIcon: String    = "checkmark"
    var style: DSButtonStyle     = .filled
    var onConfirm: () -> Void
    
    // MARK: - State
    @State private var dragOffset: CGFloat    = 0
    @State private var isConfirmed: Bool      = false
    @GestureState private var isDragging: Bool = false
    
    private let thumbSize: CGFloat    = 52
    private let buttonHeight: CGFloat = 64
    private let haptic         = UIImpactFeedbackGenerator(style: .medium)
    private let confirmHaptic  = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width
            let maxOffset  = trackWidth - thumbSize - DSSpacing.sm * 2
            let progress   = min(dragOffset / maxOffset, 1.0)
            
            ZStack(alignment: .leading) {
                
                // MARK: Track background
                RoundedRectangle(cornerRadius: DSRadius.xl)
                    .fill(trackColor.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.xl)
                            .strokeBorder(trackColor.opacity(0.3), lineWidth: 1)
                    )
                
                // MARK: Fill progress
                RoundedRectangle(cornerRadius: DSRadius.xl)
                    .fill(trackColor.opacity(0.25 + progress * 0.35))
                    .frame(width: thumbSize + DSSpacing.sm * 2 + dragOffset)
                    .animation(.interactiveSpring(), value: dragOffset)
                
                // MARK: Center label
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text(isConfirmed ? L10n.Button.confirmed : title)
                            .font(DSFont.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(trackColor)
                        if let subtitle, !isConfirmed {
                            Text(subtitle)
                                .font(DSFont.caption)
                                .foregroundStyle(trackColor.opacity(0.6))
                        }
                    }
                    .opacity(isConfirmed ? 1.0 : 1.0 - progress * 1.5)
                    .animation(.easeOut(duration: 0.15), value: progress)
                    Spacer()
                }
                
                // MARK: Thumb
                ZStack {
                    Circle()
                        .fill(trackColor)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(color: trackColor.opacity(0.4), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: isConfirmed ? confirmedIcon : icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(thumbIconColor)
                        .rotationEffect(.degrees(isConfirmed ? 0 : progress * 20))
                        .scaleEffect(isConfirmed ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: isConfirmed)
                }
                .offset(x: DSSpacing.sm + (isConfirmed ? maxOffset : dragOffset))
                .animation(isConfirmed ? .spring(response: 0.4, dampingFraction: 0.7) : nil, value: isConfirmed)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isConfirmed else { return }
                            let newOffset = max(0, min(value.translation.width, maxOffset))
                            dragOffset = newOffset
                            let newProgress = newOffset / maxOffset
                            if newProgress > 0.3 && newProgress.truncatingRemainder(dividingBy: 0.3) < 0.05 {
                                haptic.impactOccurred(intensity: newProgress)
                            }
                        }
                        .onEnded { value in
                            guard !isConfirmed else { return }
                            let progress = dragOffset / maxOffset
                            if progress > 0.85 {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    dragOffset  = maxOffset
                                    isConfirmed = true
                                }
                                confirmHaptic.notificationOccurred(.success)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    onConfirm()
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    dragOffset = 0
                                }
                                haptic.impactOccurred(intensity: 0.3)
                            }
                        }
                )
            }
            .frame(height: buttonHeight)
        }
        .frame(height: buttonHeight)
    }
    
    // MARK: - Style helpers
    private var trackColor: Color {
        switch style {
            case .destructive: return DSColor.Semantic.error
            default:           return DSColor.accent
        }
    }
    
    private var thumbIconColor: Color {
        return DSColor.Text.onAccent
    }
}

#Preview("Filled") {
    VStack(spacing: DSSpacing.xl) {
        DSSlideToConfirmButton(
            title: L10n.Button.slideToConfirm,
            subtitle: L10n.Button.cannotUndo,
            style: .filled
        ) {
            print("Confirmed!")
        }
    }
    .padding(DSSpacing.lg)
}

#Preview("Destructive") {
    VStack(spacing: DSSpacing.xl) {
        DSSlideToConfirmButton(
            title: L10n.Button.slideToDelete,
            subtitle: L10n.Button.deletePermanently,
            style: .destructive
        ) {
            print("Deleted!")
        }
    }
    .padding(DSSpacing.lg)
}
