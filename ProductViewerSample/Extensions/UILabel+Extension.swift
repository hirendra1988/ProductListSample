//
//  UILabel+Extension.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

extension UILabel {

    func textColorChange(fullText: String, changeText: String, foregroundColor: UIColor, font: UIFont) {
        let range = (fullText as NSString).range(of: changeText)
        let mutableAttributedString = NSMutableAttributedString.init(string: fullText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: foregroundColor,
                                             range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font,
                                             value: font,
                                             range: range)
        self.attributedText = mutableAttributedString
    }

}
