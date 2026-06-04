import SwiftUI

enum DSAlertStyle {
    case info
    case success
    case warning
    case destructive
}

struct DSAlertAction {
    let title: String
    let style: DSButtonStyle
    let action: () -> Void
}

struct DSAlert: View {
    
    let title: String
    var message: String?              = nil
    var style: DSAlertStyle           = .info
    var icon: String?                 = nil
    var primaryAction: DSAlertAction
    var secondaryAction: DSAlertAction? = nil
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            VStack(spacing: 0) {
                
                // MARK: Icon
                ZStack {
                    Circle()
                        .fill(alertColor.opacity(0.12))
                        .frame(width: 64, height: 64)
                    Image(systemName: icon ?? defaultIcon)
                        .font(.system(size: 28))
                        .foregroundStyle(alertColor)
                }
                .padding(.top, DSSpacing.xl)
                .padding(.bottom, DSSpacing.md)
                
                // MARK: Title
                Text(title)
                    .font(DSFont.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DSSpacing.xl)
                
                // MARK: Message
                if let message {
                    Text(message)
                        .font(DSFont.subheadline)
                        .foregroundStyle(DSColor.Text.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DSSpacing.xl)
                        .padding(.top, DSSpacing.sm)
                }
                
                // MARK: Actions
                VStack(spacing: DSSpacing.sm) {
                    DSButton(title: primaryAction.title,
                             style: primaryAction.style,
                             isFullWidth: true) {
                        primaryAction.action()
                        dismiss()
                    }
                    
                    if let secondary = secondaryAction {
                        DSButton(title: secondary.title,
                                 style: secondary.style,
                                 isFullWidth: true) {
                            secondary.action()
                            dismiss()
                        }
                    }
                }
                .padding(DSSpacing.lg)
            }
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
            .shadow(color: Color.black.opacity(0.2), radius: 24, x: 0, y: 8)
            .padding(.horizontal, DSSpacing.xl)
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
    }
    
    // MARK: - Helpers
    private func dismiss() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
    
    private var alertColor: Color {
        switch style {
            case .info:        return DSColor.accent
            case .success:     return DSColor.Semantic.success
            case .warning:     return DSColor.Semantic.warning
            case .destructive: return DSColor.Semantic.error
        }
    }
    
    private var defaultIcon: String {
        switch style {
            case .info:        return "info.circle"
            case .success:     return "checkmark.circle"
            case .warning:     return "exclamationmark.triangle"
            case .destructive: return "trash"
        }
    }
}

// MARK: - View modifier
struct DSAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let alert: () -> DSAlert
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    alert()
                        .zIndex(998)
                }
            }
    }
}

extension View {
    func dsAlert(isPresented: Binding<Bool>,
                 alert: @escaping () -> DSAlert) -> some View {
        modifier(DSAlertModifier(isPresented: isPresented, alert: alert))
    }
}

#Preview {
    DSAlertPreviewDemo()
}

private struct DSAlertPreviewDemo: View {
    @State private var showInfo        = false
    @State private var showSuccess     = false
    @State private var showWarning     = false
    @State private var showDestructive = false
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSButton(title: "Info Alert",
                     style: .filled,
                     isFullWidth: true) { showInfo = true }
            
            DSButton(title: "Success Alert",
                     style: .filled,
                     isFullWidth: true,
                     tintColor: DSColor.Semantic.success) { showSuccess = true }
            
            DSButton(title: "Warning Alert",
                     style: .outlined,
                     isFullWidth: true) { showWarning = true }
            
            DSButton(title: "Destructive Alert",
                     style: .destructive,
                     isFullWidth: true) { showDestructive = true }
        }
        .padding(DSSpacing.lg)
        .dsAlert(isPresented: $showInfo) {
            DSAlert(title: "Match Update",
                    message: "Real Madrid vs Barcelona has been rescheduled to next week.",
                    style: .info,
                    primaryAction: DSAlertAction(title: "Got it",
                                                 style: .filled,
                                                 action: {}),
                    secondaryAction: DSAlertAction(title: "View details",
                                                   style: .ghost,
                                                   action: {}),
                    isPresented: $showInfo)
        }
        .dsAlert(isPresented: $showSuccess) {
            DSAlert(title: "Player Added!",
                    message: "Mbappé has been added to your favorites.",
                    style: .success,
                    primaryAction: DSAlertAction(title: "Great!",
                                                 style: .filled,
                                                 action: {}),
                    isPresented: $showSuccess)
        }
        .dsAlert(isPresented: $showWarning) {
            DSAlert(title: "Slow Connection",
                    message: "Data may not be up to date. Check your connection.",
                    style: .warning,
                    primaryAction: DSAlertAction(title: "Retry",
                                                 style: .filled,
                                                 action: {}),
                    secondaryAction: DSAlertAction(title: "Continue anyway",
                                                   style: .ghost,
                                                   action: {}),
                    isPresented: $showWarning)
        }
        .dsAlert(isPresented: $showDestructive) {
            DSAlert(title: "Remove Favorite",
                    message: "Are you sure you want to remove Real Madrid from your favorites?",
                    style: .destructive,
                    primaryAction: DSAlertAction(title: "Remove",
                                                 style: .destructive,
                                                 action: {}),
                    secondaryAction: DSAlertAction(title: "Cancel",
                                                   style: .ghost,
                                                   action: {}),
                    isPresented: $showDestructive)
        }
    }
}
