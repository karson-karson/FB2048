//
//  LanguageSheet.swift
//  FB2048
//
//  Created by Justin on 4/8/25.
//

import Foundation
import SwiftUI
import Combine

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String = UserDefaults.standard.value(forKey: "Language") as? String ?? "en"

    func setLanguage(_ code: String) {
        UserDefaults.standard.set(code, forKey: "Language")
        UserDefaults.standard.synchronize()
        currentLanguage = code
    }
}

extension String {
    func localized() -> String {
        let language = LanguageManager.shared.currentLanguage
        guard let path = Bundle(for: FB2048Bundle.self).path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else { return self }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

struct LanguageSheet: View {
    @ObservedObject private var manager = LanguageManager.shared

    var body: some View {
        VStack(spacing: 20) {
            
            Text("language.title".localized())
                .font(.sairaSemiCondensed(14))
            
            Button(action: {
                manager.setLanguage("vi")
            }) {
                Text("language.vietnamese".localized())
                    .foregroundColor(manager.currentLanguage == "vi" ? Color.white : Color.black)
                    .font(.sairaSemiCondensed(14))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(manager.currentLanguage == "vi" ? Color(hex: "#04614C") : Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Button(action: {
                manager.setLanguage("en")
            }) {
                Text("language.english".localized())
                    .foregroundColor(manager.currentLanguage == "en" ? Color.white : Color.black)
                    .font(.sairaSemiCondensed(14))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(manager.currentLanguage == "en" ? Color(hex: "#04614C") : Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
