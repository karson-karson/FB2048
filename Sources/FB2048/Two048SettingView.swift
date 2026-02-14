//
//  Two048SettingView.swift
//  FB2048
//
//  Created by Justin on 4/8/25.
//

import SwiftUI

struct Two048SettingView: View {
    @ObservedObject private var manager = LanguageManager.shared
    @State private var isSoundOn = NNSoundService.shared.volume > 0
    @State private var showLanguageSheet = false
    
    var body: some View {
        SettingContent
    }
    
    @ViewBuilder private var SettingContent: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#04614C"), Color(hex: "#012D25")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 12) {
                toggleRow(icon: "speaker", label: "setting.sound".localized(), isOn: $isSoundOn)
                navigationRow(icon: "globe", title: "setting.language".localized(), subtitle: LanguageManager.shared.currentLanguage == "vi" ? "language.vietnamese".localized() : "language.english".localized())
                    .onTapGesture {
                        showLanguageSheet.toggle()
                    }
                navigationRow(icon: "about_us", title: "setting.aboutus".localized(), subtitle: nil)
            }
            .padding(.top, 32)
            .padding(.horizontal, 24)
        }.navigationTitle("setting.title".localized())
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isSoundOn) { isSoundOn in
            NNSoundService.shared.setVolume(isSoundOn ? 1 : 0)
        }
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSheet()
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func toggleRow(icon: String, label: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
            Text(label)
                .foregroundColor(.white)
                .font(.sairaSemiCondensed(14))
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(nil)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    private func navigationRow(icon: String,
                               title: String,
                               subtitle: String? = nil,
                               showRowIcon: Bool = true) -> some View {
        HStack(spacing: 20) {
            Image(icon)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.sairaSemiCondensed(14))
                    .foregroundColor(.white)
                if let subtitle {
                    Text(subtitle)
                        .font(.sairaSemiCondensed(12))
                        .foregroundColor(.white)
                }
            }
            
            if showRowIcon {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(1))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#F6F6F6").opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#CECECE"), lineWidth: 0.4)
        )
    }
}
