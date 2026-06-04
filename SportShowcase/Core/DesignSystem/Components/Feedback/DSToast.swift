import SwiftUI

enum DSToastType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
            case .success: return "checkmark.circle.fill"
            case .error:   return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info:    return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
            case .success: return DSColor.Semantic.success
            case .error:   return DSColor.Semantic.error
            case .warning: return DSColor.Semantic.warning
            case .info:    return DSColor.accent
        }
    }
}

enum DSToastPosition {
    case top
    case bottom
}

struct DSToastData: Equatable {
    let message: String
    let type: DSToastType
    var duration: Double = 8.0
    
    static func == (lhs: DSToastData, rhs: DSToastData) -> Bool {
        lhs.message == rhs.message && lhs.duration == rhs.duration
    }
}

// MARK: - Toast view
struct DSToastView: View {
    
    let data: DSToastData
    var position: DSToastPosition = .top
    @Binding var isShowing: Bool
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: data.type.icon)
                .font(.system(size: 18))
                .foregroundStyle(data.type.color)
            
            Text(data.message)
                .font(DSFont.subheadline)
                .foregroundStyle(DSColor.Text.primary)
                .lineLimit(2)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(DSColor.Text.tertiary)
            }
        }
        .padding(DSSpacing.md)
        .background(DSColor.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
        .overlay(RoundedRectangle(cornerRadius: DSRadius.lg)
            .strokeBorder(data.type.color.opacity(0.3), lineWidth: 1))
        .offset(y: offset)
        .opacity(opacity)
        .padding(.horizontal, DSSpacing.lg)
        .onAppear { show() }
    }
    
    private func show() {
        let startOffset: CGFloat = position == .top ? -80 : 80
        offset = startOffset
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            offset  = 0
            opacity = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + data.duration) {
            dismiss()
        }
    }
    
    private func dismiss() {
        let endOffset: CGFloat = position == .top ? -80 : 80
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            offset  = endOffset
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShowing = false
        }
    }
}

// MARK: - Toast modifier
struct DSToastModifier: ViewModifier {
    
    @Binding var toast: DSToastData?
    var position: DSToastPosition = .top
    @State private var isShowing = false
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: position == .top ? .top : .bottom) {
                if let toast, isShowing {
                    DSToastView(data: toast,
                                position: position,
                                isShowing: $isShowing)
                    .padding(.top, position == .top ? DSSpacing.xl : 0)
                    .padding(.bottom, position == .bottom ? DSSpacing.xl : 0)
                    .transition(.move(edge: position == .top ? .top : .bottom)
                        .combined(with: .opacity))
                    .zIndex(999)
                }
            }
            .onChange(of: toast) { _, newValue in
                if newValue != nil { isShowing = true }
            }
            .onChange(of: isShowing) { _, showing in
                if !showing { toast = nil }
            }
    }
}

extension View {
    func dsToast(_ toast: Binding<DSToastData?>,
                 position: DSToastPosition = .top) -> some View {
        modifier(DSToastModifier(toast: toast, position: position))
    }
}

#Preview {
    DSToastPreviewDemo()
}

private struct DSToastPreviewDemo: View {
    @State private var toast: DSToastData?
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSButton(title: "Show Success",
                     style: .filled,
                     icon: "checkmark.circle",
                     isFullWidth: true) {
                toast = DSToastData(message: "Player added to favorites!",
                                    type: .success)
            }
            DSButton(title: "Show Error",
                     style: .destructive,
                     icon: "xmark.circle",
                     isFullWidth: true) {
                toast = DSToastData(message: "Failed to load match data",
                                    type: .error)
            }
            DSButton(title: "Show Warning",
                     style: .outlined,
                     icon: "exclamationmark.triangle",
                     isFullWidth: true) {
                toast = DSToastData(message: "Connection is slow",
                                    type: .warning)
            }
            DSButton(title: "Show Info",
                     style: .ghost,
                     icon: "info.circle",
                     isFullWidth: true) {
                toast = DSToastData(message: "Match starts in 10 minutes",
                                    type: .info)
            }
        }
        .padding(DSSpacing.lg)
        .dsToast($toast)
    }
}
