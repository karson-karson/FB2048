//
//  MainCell.swift
//  FabetApp
//
//  Created by Justin on 2/8/25.
//

import SwiftUI

struct MainCell: View {
    let number: Int

    var body: some View {
        Text(number == 0 ? "" : "\(number)")
            .frame(width: 70, height: 70)
            .background(colorForValue(number))
            .foregroundColor(.white)
            .font(.title.bold())
            .cornerRadius(8)
            .scaleEffect(number > 0 ? 1.0 : 0.9)
            .opacity(number > 0 ? 1 : 0.6)
    }

    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color.yellow
        case 4:
            return Color.orange
        case 8:
            return Color.pink
        case 16:
            return Color.purple
        case 32:
            return Color.red
        case 64:
            return Color.red.opacity(0.8)
        case 128:
            return Color.blue
        case 256:
            return Color.blue.opacity(0.8)
        case 512:
            return Color.green
        case 1024:
            return Color.green.opacity(0.8)
        case 2048:
            return Color(red: 1, green: 215/255, blue: 0)
        case 4096:
            return Color.indigo
        case 8192:
            return Color.purple.opacity(0.5)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}
