import SwiftUI

struct ShowcaseSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(DSFont.headline)
                .foregroundStyle(DSColor.Text.primary)
            content()
        }
    }
}
