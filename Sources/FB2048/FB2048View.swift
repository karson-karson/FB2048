//
//  FB2048View.swift
//  FabetApp
//
//  Created by Justin on 5/8/25.
//

import SwiftUI

public struct FB2048View: View {
    @State private var isActive = false

    public init() {
        UIFont.fb2048RegisterFonts()
    }

    public var body: some View {
        Two048View(isActive: $isActive)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
    }
}

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255

        self.init(red: r, green: g, blue: b, opacity: alpha)
    }
}

extension Font {
    static func sairaSemiCondensed(_ size: CGFloat) -> Font {
        let font = UIFont(name: "SairaSemiCondensed-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        
        return Font(font)
    }
}
