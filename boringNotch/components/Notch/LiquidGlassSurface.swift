//
//  LiquidGlassSurface.swift
//  boringNotch
//
//  Liquid Glass surface for Compact Mode — native on macOS 26+, fallback on older.
//

import SwiftUI

/// A glass surface that uses native Liquid Glass on macOS 26+ and falls back to
/// ultraThinMaterial with subtle edge highlights on macOS 14–25.
struct LiquidGlassSurface: View {
    let topCornerRadius: CGFloat
    let bottomCornerRadius: CGFloat

    init(
        topCornerRadius: CGFloat = 35,
        bottomCornerRadius: CGFloat = 35
    ) {
        self.topCornerRadius = topCornerRadius
        self.bottomCornerRadius = bottomCornerRadius
    }

    var body: some View {
        if #available(macOS 26.0, *) {
            nativeGlass
        } else {
            fallbackGlass
        }
    }

    // MARK: - Native Liquid Glass (macOS 26+)

    @available(macOS 26.0, *)
    private var nativeGlass: some View {
        // Use the same NotchShape that clips the panel so the glass matches
        // the container geometry exactly. The glassEffect(in:) modifier applies
        // the native Liquid Glass material within the given shape.
        Rectangle()
            .glassEffect(in: NotchShape(
                topCornerRadius: topCornerRadius,
                bottomCornerRadius: bottomCornerRadius
            ))
    }

    // MARK: - Fallback (macOS 14–25)

    private var fallbackGlass: some View {
        ZStack {
            // Base translucent material — the closest built-in equivalent to
            // Liquid Glass on older macOS versions.
            Rectangle()
                .fill(.ultraThinMaterial)

            // Subtle top-edge highlight (1pt) to suggest the glass "lip".
            // Matches Apple's glass spec: a barely-visible bright line at the
            // top edge that catches light.
            LinearGradient(
                colors: [
                    .white.opacity(0.18),
                    .white.opacity(0.06),
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 2)
            .frame(maxHeight: .infinity, alignment: .top)

            // Very subtle inner stroke for depth — keeps the panel from
            // feeling like a flat sheet.
            Rectangle()
                .stroke(.white.opacity(0.05), lineWidth: 0.5)
        }
        .clipShape(NotchShape(
            topCornerRadius: topCornerRadius,
            bottomCornerRadius: bottomCornerRadius
        ))
    }
}

#Preview("Compact Glass Surface") {
    LiquidGlassSurface(topCornerRadius: 35, bottomCornerRadius: 35)
        .frame(width: 336, height: 160)
        .padding(40)
        .background(
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}