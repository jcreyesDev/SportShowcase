import SwiftUI

struct DSSearchBar: View {
    
    @Binding var text: String
    var placeholder: String      = L10n.General.search
    var onSubmit: (() -> Void)?  = nil
    var onCancel: (() -> Void)?  = nil
    
    @FocusState private var isFocused: Bool
    @State private var showCancel: Bool = false
    
    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            searchField
            if showCancel {
                cancelButton
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showCancel)
        .onChange(of: isFocused) { _, focused in
            showCancel = focused
        }
    }
    
    // MARK: - Search field
    private var searchField: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(isFocused ? DSColor.accent : DSColor.Text.tertiary)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            TextField(placeholder, text: $text)
                .font(DSFont.body)
                .foregroundStyle(DSColor.Text.primary)
                .focused($isFocused)
                .onSubmit { onSubmit?() }
                .submitLabel(.search)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(DSColor.Text.tertiary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .frame(height: 44)
        .background(DSColor.Background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.xl)
            .strokeBorder(isFocused ? DSColor.accent : Color.clear, lineWidth: 1.5))
        .animation(.spring(response: 0.3), value: text.isEmpty)
    }
    
    // MARK: - Cancel button
    private var cancelButton: some View {
        Button {
            text = ""
            isFocused = false
            onCancel?()
        } label: {
            Text(L10n.General.cancel)
                .font(DSFont.subheadline)
                .foregroundStyle(DSColor.accent)
        }
    }
}

#Preview {
    @Previewable @State var searchText = ""
    
    VStack(spacing: DSSpacing.xl) {
        DSSearchBar(text: $searchText)
        DSSearchBar(text: $searchText, placeholder: "Search players...")
        Text("Searching: \(searchText.isEmpty ? "—" : searchText)")
            .font(DSFont.caption)
            .foregroundStyle(DSColor.Text.tertiary)
    }
    .padding(DSSpacing.lg)
}
