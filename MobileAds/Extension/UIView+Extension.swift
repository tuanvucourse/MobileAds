//
//  UIView+Extension.swift
//  MobileAds
//
//  Created by ANH VU on 21/12/2022.
//

import UIKit
import Foundation

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
