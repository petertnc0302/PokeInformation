//
//  Color+Extension.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 22/6/24.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    static func backgroundType(type: String?) -> UIColor {        
        switch type?.capitalized {
        case "Bug": return UIColor(hex: "#A8B820")
        case "Dark": return UIColor(hex: "#705848")
        case "Dragon": return UIColor(hex: "#7038F8")
        case "Electric": return UIColor(hex: "#F8D030")
        case "Fairy": return UIColor(hex: "#EE99AC")
        case "Fighting": return UIColor(hex: "#C03028")
        case "Fire": return UIColor(hex: "#F08030")
        case "Flying": return UIColor(hex: "#A890F0")
        case "Ghost": return UIColor(hex: "#705898")
        case "Grass": return UIColor(hex: "#78C850")
        case "Ground": return UIColor(hex: "#E0C068")
        case "Ice": return UIColor(hex: "#98D8D8")
        case "Normal": return UIColor(hex: "#A8A878")
        case "Poison": return UIColor(hex: "#A040A0")
        case "Psychic": return UIColor(hex: "#F85888")
        case "Rock": return UIColor(hex: "#B8A038")
        case "Steel": return UIColor(hex: "#B8B8D0")
        case "Water": return UIColor(hex: "#6890F0")
        default: return .green
        }
    }
}
