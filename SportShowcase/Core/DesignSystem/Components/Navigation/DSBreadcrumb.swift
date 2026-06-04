    //
    //  DSBreadcrumb.swift
    //  SportShowcase
    //

import SwiftUI

struct DSBreadcrumbItem: Identifiable {
    let id: String
    let title: String
    var icon: String?        = nil
    var onTap: (() -> Void)? = nil
}

struct DSBreadcrumb: View {
    
    let items: [DSBreadcrumbItem]
    var tintColor: Color         = DSColor.accent
    var separator: String        = "chevron.right"
    var truncateMiddle: Bool     = true
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSSpacing.xs) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let isLast = index == items.count - 1
                    
                    HStack(spacing: DSSpacing.xs) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .font(.system(size: 11))
                                .foregroundStyle(isLast ? DSColor.Text.primary : tintColor)
                        }
                        
                        Text(item.title)
                            .font(DSFont.footnote)
                            .fontWeight(isLast ? .medium : .regular)
                            .foregroundStyle(isLast ? DSColor.Text.primary : tintColor)
                            .lineLimit(1)
                    }
                    .onTapGesture { item.onTap?() }
                    .disabled(isLast)
                    
                    if !isLast {
                        Image(systemName: separator)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(DSColor.Text.tertiary)
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: DSSpacing.xl) {
        
        DSBreadcrumb(items: [
            DSBreadcrumbItem(id: "1", title: "Home", icon: "house", onTap: {}),
            DSBreadcrumbItem(id: "2", title: "Leagues", onTap: {}),
            DSBreadcrumbItem(id: "3", title: "Premier League")
        ])
        
        DSBreadcrumb(items: [
            DSBreadcrumbItem(id: "1", title: "Home", icon: "house", onTap: {}),
            DSBreadcrumbItem(id: "2", title: "Teams", onTap: {}),
            DSBreadcrumbItem(id: "3", title: "Real Madrid", onTap: {}),
            DSBreadcrumbItem(id: "4", title: "Players", onTap: {}),
            DSBreadcrumbItem(id: "5", title: "Kylian Mbappé")
        ],
                     tintColor: DSColor.secondary)
        
        DSBreadcrumb(items: [
            DSBreadcrumbItem(id: "1", title: "Home", icon: "house", onTap: {}),
            DSBreadcrumbItem(id: "2", title: "Matches", onTap: {}),
            DSBreadcrumbItem(id: "3", title: "Champions League")
        ],
                     tintColor: DSColor.Semantic.success,
                     separator: "chevron.right.2")
    }
    .padding(DSSpacing.lg)
}
