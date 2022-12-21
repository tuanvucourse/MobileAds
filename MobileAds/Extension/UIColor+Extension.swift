//
//  UIColor+Extension.swift
//  EasyPhone
//
//  Created by ANH VU on 11/01/2022.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    func gradientColor(bounds: CGRect, colorStart: UIColor = .white, colorEnd: UIColor = .white, isHorizontalMode: Bool = true) -> UIColor? {
        let getGradientLayer = getGradientLayer(bounds: bounds, colorStart: colorStart, colorEnd: colorEnd, isHorizontalMode: isHorizontalMode)
        UIGraphicsBeginImageContext(getGradientLayer.bounds.size)
        guard (UIGraphicsGetCurrentContext() != nil) else {return UIColor(hex: 0xFD5900)}
        getGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    func getGradientLayer(bounds : CGRect, colorStart: UIColor = .white, colorEnd: UIColor = .white, isHorizontalMode: Bool) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorStart.cgColor ,colorEnd.cgColor]
        gradient.startPoint = isHorizontalMode ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        gradient.endPoint = isHorizontalMode ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1)
        return gradient
    }

}
