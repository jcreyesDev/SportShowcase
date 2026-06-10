import SwiftUI

struct CatalogView: View {
    
    @State private var searchText = ""
    @State private var router     = NavigationRouter.shared
    @State private var selectedCategory: ComponentCategory? = nil
    
    private let categories: [ComponentCategory] = ComponentCategory.allCases
    
    private var filtered: [ComponentCategory] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.lg) {
                    DSSearchBar(text: $searchText)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.md)
                    
                    LazyVStack(spacing: DSSpacing.sm) {
                        ForEach(filtered) { category in
                            categoryCard(category)
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                    }
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.bottom, DSSpacing.lg)
                }
            }
            .navigationTitle(L10n.Catalog.title)
            .navigationDestination(item: $selectedCategory) { category in
                category.destination
            }
        }
        .coachMarkOverlay(key: "playground_onboarding")
    }
    
    private func categoryCard(_ category: ComponentCategory) -> some View {
        HStack(spacing: DSSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .fill(category.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(category.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(DSFont.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                Text("\(category.count) components")
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Text.tertiary)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DSColor.Text.tertiary)
        }
        .padding(DSSpacing.lg)
        .background(DSColor.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.lg)
            .strokeBorder(DSColor.Text.tertiary.opacity(0.1), lineWidth: 0.5))
        .contentShape(Rectangle())
    }
}

    // MARK: - Component Category
enum ComponentCategory: String, CaseIterable, Identifiable, Hashable {
    case buttons    = "buttons"
    case cards      = "cards"
    case inputs     = "inputs"
    case feedback   = "feedback"
    case data       = "data"
    case navigation = "navigation"
    case layout     = "layout"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .buttons:    return "Buttons"
            case .cards:      return "Cards"
            case .inputs:     return "Inputs"
            case .feedback:   return "Feedback"
            case .data:       return "Data"
            case .navigation: return "Navigation"
            case .layout:     return "Layout"
        }
    }
    
    var icon: String {
        switch self {
            case .buttons:    return "hand.tap"
            case .cards:      return "rectangle.stack"
            case .inputs:     return "slider.horizontal.3"
            case .feedback:   return "bell"
            case .data:       return "tablecells"
            case .navigation: return "arrow.left.arrow.right"
            case .layout:     return "square.grid.2x2"
        }
    }
    
    var color: Color {
        switch self {
            case .buttons:    return DSColor.accent
            case .cards:      return DSColor.secondary
            case .inputs:     return DSColor.Semantic.success
            case .feedback:   return DSColor.Semantic.warning
            case .data:       return DSColor.Semantic.error
            case .navigation: return Color.purple
            case .layout:     return Color.orange
        }
    }
    
    var count: Int {
        switch self {
            case .buttons:    return 2
            case .cards:      return 5
            case .inputs:     return 6
            case .feedback:   return 6
            case .data:       return 3
            case .navigation: return 3
            case .layout:     return 3
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .buttons:    ButtonShowcaseView()
            case .cards:      CardShowcaseView()
            case .inputs:     InputShowcaseView()
            case .feedback:   FeedbackShowcaseView()
            case .data:       DataShowcaseView()
            case .navigation: NavigationShowcaseView()
            case .layout:     LayoutShowcaseView()
        }
    }
}

#Preview {
    CatalogView()
}
