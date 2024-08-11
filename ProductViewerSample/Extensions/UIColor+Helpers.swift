import UIKit

extension UIColor {
    static let grayDarkest = UIColor(hex: 0x333333)
    static let grayMedium = UIColor(hex: 0x888888)
    static let targetRed = UIColor(hex: 0xAA0000)
    static let targetTextGreen = UIColor(hex: 0x008300)
    static let textLightGray = UIColor(hex: 0x666666)
    static let thinBorderGray = UIColor(hex: 0xD6D6D6)
    static let background = UIColor(hex: 0xF7F7F7)
    static let extraThinGrey = UIColor(red: 230.0/255.0,
                                       green: 230.0/255.0,
                                       blue: 230.0/255.0,
                                       alpha: 1.0)
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xff) / 255
        let green = CGFloat((hex >> 08) & 0xff) / 255
        let blue = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
