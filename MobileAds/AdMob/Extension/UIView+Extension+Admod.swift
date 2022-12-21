//
//  UIView+Extension+Admod.swift
//  MobileAds
//
//  Created by ANH VU on 19/01/2022.
//

import Foundation
import UIKit

extension UIView {
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
            guard let rating = starRating?.doubleValue else {
                return nil
            }
            if rating >= 5 {
                return UIImage(named: "stars_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 4.5 {
                return UIImage(named: "stars_4_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 4 {
                return UIImage(named: "stars_4.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 3.5 {
                return UIImage(named: "stars_3_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else {
                return nil
            }
    }
}

@IBDesignable
class DesignableGradient: UIView {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: false)
    }
    
}
@IBDesignable
class DesignableGradientButton: UIButton {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: false)
    }
    
}

@IBDesignable
class DesignableGradientLablel: UILabel {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: false)
    }
    
}

@IBDesignable
class DesignableGradientLablelText: UILabel {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: false)
    }
    
}
