//
//  UIFont+Custom.swift
//

import UIKit


extension UIFont {

    enum Custom {
        private static let pointSize: CGFloat = UIFont.labelFontSize

        private static let fallbackLight = UIFont.systemFont(ofSize: pointSize, weight: .light)
        private static let fallbackRegular = UIFont.systemFont(ofSize: pointSize, weight: .regular)
        private static let fallbackMedium = UIFont.systemFont(ofSize: pointSize, weight: .medium)
        private static let fallbackBold = UIFont.systemFont(ofSize: pointSize, weight: .bold)
        private static let fallbackSemibold = UIFont.systemFont(ofSize: pointSize, weight: .semibold)


        static let light = UIFont(name: "Whitney-Light", size: pointSize) ?? Custom.fallbackLight
        static let book = UIFont(name: "Whitney-Book", size: pointSize) ?? Custom.fallbackMedium
        static let medium = UIFont(name: "Whitney-Medium", size: pointSize) ?? Custom.fallbackMedium
        static let bold = UIFont(name: "Whitney-Bold", size: pointSize) ?? Custom.fallbackBold
        static let semibold = UIFont(name: "Whitney-Semibold", size: pointSize) ?? Custom.fallbackSemibold
    }
}
