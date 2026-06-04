import SwiftUI

// MARK: - Shimmer modifier
struct ShimmerModifier: ViewModifier {
    
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { geo in
                LinearGradient(
                    stops: [
                        .init(color: .clear,                                    location: 0),
                        .init(color: DSColor.Text.onAccent.opacity(0.25),       location: 0.4),
                        .init(color: DSColor.Text.onAccent.opacity(0.5),        location: 0.5),
                        .init(color: DSColor.Text.onAccent.opacity(0.25),       location: 0.6),
                        .init(color: .clear,                                    location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing)
                .frame(width: geo.size.width * 2.5)
                .offset(x: phase * geo.size.width * 2.5)
                .blendMode(.plusLighter)
            })
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Base shape
struct DSSkeletonShape: View {
    
    var width: CGFloat?       = nil
    var height: CGFloat       = 16
    var cornerRadius: CGFloat = DSRadius.sm
    var isCircle: Bool        = false
    
    var body: some View {
        Group {
            if isCircle {
                Circle()
                    .fill(DSColor.Text.tertiary.opacity(0.12))
                    .shimmer()
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(DSColor.Text.tertiary.opacity(0.12))
                    .frame(height: height)
                    .shimmer()
            }
        }
        .frame(width: width)
    }
}

// MARK: - Skeleton variants
struct DSTeamCardSkeleton: View {
    var body: some View {
        DSCard(style: .elevated) {
            HStack(spacing: DSSpacing.md) {
                DSSkeletonShape(width: 52, height: 52, cornerRadius: DSRadius.sm)
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSSkeletonShape(width: 120, height: 14)
                    DSSkeletonShape(width: 80, height: 12)
                    DSSkeletonShape(width: 100, height: 10)
                }
                Spacer()
            }
        }
    }
}

struct DSPlayerCardSkeleton: View {
    var body: some View {
        DSCard(style: .elevated) {
            HStack(spacing: DSSpacing.md) {
                DSSkeletonShape(width: 56, height: 56, isCircle: true)
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSSkeletonShape(width: 130, height: 14)
                    DSSkeletonShape(width: 60, height: 20, cornerRadius: DSRadius.full)
                    DSSkeletonShape(width: 90, height: 10)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: DSSpacing.sm) {
                    DSSkeletonShape(width: 40, height: 12)
                    DSSkeletonShape(width: 40, height: 12)
                    DSSkeletonShape(width: 40, height: 12)
                }
            }
        }
    }
}

struct DSMatchCardSkeleton: View {
    var body: some View {
        DSCard(style: .elevated) {
            VStack(spacing: DSSpacing.md) {
                HStack {
                    DSSkeletonShape(width: 100, height: 10)
                    Spacer()
                    DSSkeletonShape(width: 60, height: 20, cornerRadius: DSRadius.full)
                }
                HStack(spacing: DSSpacing.lg) {
                    VStack(spacing: DSSpacing.sm) {
                        DSSkeletonShape(width: 44, height: 44, cornerRadius: DSRadius.sm)
                        DSSkeletonShape(width: 70, height: 10)
                    }
                    VStack(spacing: DSSpacing.xs) {
                        DSSkeletonShape(width: 80, height: 24)
                        DSSkeletonShape(width: 100, height: 10)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: DSSpacing.sm) {
                        DSSkeletonShape(width: 44, height: 44, cornerRadius: DSRadius.sm)
                        DSSkeletonShape(width: 70, height: 10)
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: DSSpacing.lg) {
            Text("Team Card")
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
            DSTeamCardSkeleton()
            
            Text("Player Card")
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
            DSPlayerCardSkeleton()
            
            Text("Match Card")
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Text.tertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
            DSMatchCardSkeleton()
        }
        .padding(DSSpacing.lg)
    }
}
