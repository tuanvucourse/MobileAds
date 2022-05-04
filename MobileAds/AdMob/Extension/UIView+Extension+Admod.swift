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
                return UIImage(named: "stars_5")
            } else if rating >= 4.5 {
                return UIImage(named: "stars_4_5")
            } else if rating >= 4 {
                return UIImage(named: "stars_4")
            } else if rating >= 3.5 {
                return UIImage(named: "stars_3_5")
            } else {
                return nil
            }
    }
}
