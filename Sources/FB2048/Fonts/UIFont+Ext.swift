//
//  UIFont+Ext.swift
//  FB2048
//
//  Created by Karson on 2/14/26.
//

import UIKit

extension UIFont {
    public static func fb2048RegisterFonts() {
        guard let fontURLs = Bundle(for: FB2048Bundle.self).urls(forResourcesWithExtension: "ttf", subdirectory: nil) else {
            print("❌ Fonts not found")
            return
        }

        fontURLs.forEach { url in
            var error: Unmanaged<CFError>?
            let pass = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            if !pass {
                if let cfError = error?.takeRetainedValue() {
                    let desc = (cfError as Swift.Error).localizedDescription
                    print("❌ Error registering font: \(desc)")
                }
            }
        }
    }
}
