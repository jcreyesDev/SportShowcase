import SwiftUI

// MARK: - Configuration enums
enum DSTextFieldStyle {
    case outlined
    case filled
    case underlined
}

enum DSTextFieldState {
    case normal
    case focused
    case success(String)
    case error(String)
    case disabled
}

enum DSTextFieldType {
    case text
    case password
    case email
    case number
    case phone
}

// MARK: - Main Component
struct DSTextField: View {
    
    let label: String
    @Binding var text: String
    var placeholder: String          = ""
    var style: DSTextFieldStyle      = .outlined
    var state: DSTextFieldState      = .normal
    var type: DSTextFieldType        = .text
    var icon: String?                = nil
    var trailingIcon: String?        = nil
    var helperText: String?          = nil
    var onTrailingIconTap: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    @State private var isSecured: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            labelView
            inputContainer
            bottomText
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: stateDescription)
    }
    
    // MARK: - Label
    private var labelView: some View {
        Text(label)
            .font(DSFont.footnote)
            .fontWeight(.medium)
            .foregroundStyle(labelColor)
    }
    
    // MARK: - Input container
    @ViewBuilder
    private var inputContainer: some View {
        switch style {
            case .outlined:  outlinedInput
            case .filled:    filledInput
            case .underlined: underlinedInput
        }
    }
    
    private var outlinedInput: some View {
        inputContent
            .background(DSColor.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.md)
                .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1))
    }
    
    private var filledInput: some View {
        inputContent
            .background(DSColor.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.md)
                .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 0))
    }
    
    private var underlinedInput: some View {
        VStack(spacing: 0) {
            inputContent
                .background(Color.clear)
            Rectangle()
                .fill(borderColor)
                .frame(height: isFocused ? 2 : 1)
        }
    }
    
        // MARK: - Input content
    private var inputContent: some View {
        HStack(spacing: DSSpacing.sm) {
            
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }
            
            Group {
                if type == .password && isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .autocorrectionDisabled(type == .email || type == .password)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .font(DSFont.body)
            .foregroundStyle(isDisabled ? DSColor.Text.tertiary : DSColor.Text.primary)
            .focused($isFocused)
            .disabled(isDisabled)
            
            trailingContent
        }
        .padding(.horizontal, DSSpacing.md)
        .frame(height: 48)
    }
    
        // MARK: - Trailing content
    @ViewBuilder
    private var trailingContent: some View {
        if type == .password {
            Button { isSecured.toggle() } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .font(.system(size: 16))
                    .foregroundStyle(DSColor.Text.tertiary)
            }
        } else if case .success = state {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(DSColor.Semantic.success)
        } else if case .error = state {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(DSColor.Semantic.error)
        } else if let trailingIcon {
            Button { onTrailingIconTap?() } label: {
                Image(systemName: trailingIcon)
                    .font(.system(size: 16))
                    .foregroundStyle(DSColor.Text.tertiary)
            }
        }
    }
    
        // MARK: - Bottom text
    @ViewBuilder
    private var bottomText: some View {
        if case .error(let message) = state {
            Text(message)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Semantic.error)
        } else if case .success(let message) = state {
            Text(message)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Semantic.success)
        } else if let helperText {
            Text(helperText)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
        }
    }
    
        // MARK: - Style helpers
    private var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    private var borderColor: Color {
        if case .error = state   { return DSColor.Semantic.error }
        if case .success = state { return DSColor.Semantic.success }
        if case .disabled = state { return DSColor.Text.tertiary.opacity(0.3) }
        if isFocused             { return DSColor.accent }
        return DSColor.Text.tertiary.opacity(0.3)
    }
    
    private var labelColor: Color {
        if case .error = state   { return DSColor.Semantic.error }
        if case .success = state { return DSColor.Semantic.success }
        if case .disabled = state { return DSColor.Text.tertiary }
        if isFocused             { return DSColor.accent }
        return DSColor.Text.secondary
    }
    
    private var iconColor: Color {
        isFocused ? DSColor.accent : DSColor.Text.tertiary
    }
    
    private var stateDescription: String {
        switch state {
            case .normal:       return "normal"
            case .focused:      return "focused"
            case .success:      return "success"
            case .error:        return "error"
            case .disabled:     return "disabled"
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch type {
            case .email:  return .emailAddress
            case .number: return .numberPad
            case .phone:  return .phonePad
            default:      return .default
        }
    }
    
    private var textContentType: UITextContentType? {
        switch type {
            case .email:    return .emailAddress
            case .password: return .password
            case .phone:    return .telephoneNumber
            default:        return nil
        }
    }
    
    private var autocapitalization: TextInputAutocapitalization {
        switch type {
            case .email, .password: return .never
            default:                return .sentences
        }
    }
}

#Preview("Styles") {
    @Previewable @State var text1 = ""
    @Previewable @State var text2 = ""
    @Previewable @State var text3 = ""
    
    VStack(spacing: DSSpacing.lg) {
        DSTextField(label: "Outlined",
                    text: $text1,
                    placeholder: "Enter text...",
                    style: .outlined)
        
        DSTextField(label: "Filled",
                    text: $text2,
                    placeholder: "Enter text...",
                    style: .filled)
        
        DSTextField(label: "Underlined",
                    text: $text3,
                    placeholder: "Enter text...",
                    style: .underlined)
    }
    .padding(DSSpacing.lg)
}

#Preview("States") {
    @Previewable @State var text1 = "valid@email.com"
    @Previewable @State var text2 = "wrong input"
    @Previewable @State var text3 = "disabled"
    @Previewable @State var text4 = ""
    
    VStack(spacing: DSSpacing.lg) {
        DSTextField(label: "Success",
                    text: $text1,
                    placeholder: "Email",
                    state: .success("Valid email address"),
                    type: .email,
                    icon: "envelope")
        
        DSTextField(label: "Error",
                    text: $text2,
                    placeholder: "Username",
                    state: .error("Username already taken"),
                    icon: "person")
        
        DSTextField(label: "Disabled",
                    text: $text3,
                    placeholder: "Disabled field",
                    state: .disabled)
        
        DSTextField(label: "Password",
                    text: $text4,
                    placeholder: "Enter password",
                    type: .password,
                    icon: "lock",
                    helperText: "Minimum 8 characters")
    }
    .padding(DSSpacing.lg)
}
