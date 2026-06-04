import SwiftUI

enum DSPageIndicatorStyle {
    case dots
    case pills
    case numbers
    case dashes
}

struct DSPageIndicator: View {
    
    @Binding var currentPage: Int
    let pageCount: Int
    var style: DSPageIndicatorStyle = .dots
    var tintColor: Color            = DSColor.accent
    var inactiveColor: Color        = DSColor.Text.tertiary.opacity(0.3)
    var animated: Bool              = true
    
    var body: some View {
        switch style {
            case .dots:    dotsIndicator
            case .pills:   pillsIndicator
            case .numbers: numbersIndicator
            case .dashes:  dashesIndicator
        }
    }
    
    // MARK: - Dots
    private var dotsIndicator: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? tintColor : inactiveColor)
                    .frame(width: index == currentPage ? 10 : 7,
                           height: index == currentPage ? 10 : 7)
                    .animation(animated ? .spring(response: 0.3) : nil,
                               value: currentPage)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            currentPage = index
                        }
                    }
            }
        }
    }
    
    // MARK: - Pills
    private var pillsIndicator: some View {
        HStack(spacing: DSSpacing.xs) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? tintColor : inactiveColor)
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(animated ? .spring(response: 0.3, dampingFraction: 0.7) : nil,
                               value: currentPage)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            currentPage = index
                        }
                    }
            }
        }
    }
    
    // MARK: - Numbers
    private var numbersIndicator: some View {
        HStack(spacing: DSSpacing.sm) {
            Button {
                guard currentPage > 0 else { return }
                withAnimation(.spring(response: 0.3)) { currentPage -= 1 }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(currentPage > 0 ? tintColor : inactiveColor)
            }
            .disabled(currentPage == 0)
            
            Text("\(currentPage + 1) / \(pageCount)")
                .font(DSFont.footnote)
                .fontWeight(.medium)
                .foregroundStyle(DSColor.Text.secondary)
                .monospacedDigit()
            
            Button {
                guard currentPage < pageCount - 1 else { return }
                withAnimation(.spring(response: 0.3)) { currentPage += 1 }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(currentPage < pageCount - 1 ? tintColor : inactiveColor)
            }
            .disabled(currentPage == pageCount - 1)
        }
    }
    
    // MARK: - Dashes
    private var dashesIndicator: some View {
        HStack(spacing: DSSpacing.xs) {
            ForEach(0..<pageCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: DSRadius.full)
                    .fill(index == currentPage ? tintColor : inactiveColor)
                    .frame(width: 16, height: 3)
                    .animation(animated ? .spring(response: 0.3) : nil,
                               value: currentPage)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            currentPage = index
                        }
                    }
            }
        }
    }
}

// MARK: - Page view wrapper
struct DSPageView<Content: View>: View {
    
    @Binding var currentPage: Int
    let pageCount: Int
    var indicatorStyle: DSPageIndicatorStyle = .pills
    var tintColor: Color                     = DSColor.accent
    @ViewBuilder let content: (Int) -> Content
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            TabView(selection: $currentPage) {
                ForEach(0..<pageCount, id: \.self) { index in
                    content(index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.8),
                       value: currentPage)
            
            DSPageIndicator(currentPage: $currentPage,
                            pageCount: pageCount,
                            style: indicatorStyle,
                            tintColor: tintColor)
        }
    }
}

#Preview {
    PageIndicatorPreviewDemo()
}

private struct PageIndicatorPreviewDemo: View {
    
    private struct TeamPage: Identifiable {
        let id: Int
        let name: String
    }
    
    @State private var currentPage = 0
    
    private let teams = [
        TeamPage(id: 0, name: "Real Madrid"),
        TeamPage(id: 1, name: "Barcelona"),
        TeamPage(id: 2, name: "Atletico Madrid"),
        TeamPage(id: 3, name: "Sevilla")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                
                TabView(selection: $currentPage) {
                    ForEach(teams) { team in
                        DSCard(style: .elevated) {
                            VStack(spacing: DSSpacing.md) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(DSColor.accent)
                                Text(team.name)
                                    .font(DSFont.headline)
                                    .foregroundStyle(DSColor.Text.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(DSSpacing.xl)
                        }
                        .tag(team.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 180)
                .padding(.horizontal, DSSpacing.xs)
                
                VStack(spacing: DSSpacing.lg) {
                    VStack(spacing: DSSpacing.xs) {
                        Text("Dots").font(DSFont.caption).foregroundStyle(DSColor.Text.tertiary)
                        DSPageIndicator(currentPage: $currentPage,
                                        pageCount: teams.count,
                                        style: .dots)
                    }
                    VStack(spacing: DSSpacing.xs) {
                        Text("Pills").font(DSFont.caption).foregroundStyle(DSColor.Text.tertiary)
                        DSPageIndicator(currentPage: $currentPage,
                                        pageCount: teams.count,
                                        style: .pills)
                    }
                    VStack(spacing: DSSpacing.xs) {
                        Text("Numbers").font(DSFont.caption).foregroundStyle(DSColor.Text.tertiary)
                        DSPageIndicator(currentPage: $currentPage,
                                        pageCount: teams.count,
                                        style: .numbers)
                    }
                    VStack(spacing: DSSpacing.xs) {
                        Text("Dashes").font(DSFont.caption).foregroundStyle(DSColor.Text.tertiary)
                        DSPageIndicator(currentPage: $currentPage,
                                        pageCount: teams.count,
                                        style: .dashes)
                    }
                }
            }
            .padding(DSSpacing.lg)
        }
    }
}
