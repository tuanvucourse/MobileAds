//
//  UIViewControll+Extension+Ads.swift
//  MobileAds
//
//  Created by ANH VU on 08/03/2022.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func showLoadingDotAds(backgroundColor: UIColor = .clear, textLoading: String? = nil, subTextLoading: String? = nil) {
        let keyWindow = self.keyWindowAds ?? self.view
        
        if self.view.subviews.first(where: {$0.tag == -111}) != nil {
            return
        }
        let overLayView = UIView()
        overLayView.backgroundColor = backgroundColor
        overLayView.tag = -112
        overLayView.frame = keyWindow!.frame
        
        let dotView = UIActivityIndicatorView()
        dotView.tag = -111
        self.view.addSubview(overLayView)
        overLayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overLayView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dotView.startAnimating()
        
        if let textLoading = textLoading {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 0
            var att = NSMutableAttributedString(string: textLoading, attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
            if let subTextLoading = subTextLoading {
                att.append(NSAttributedString(string: "\n"))
                att.append(NSAttributedString(string: subTextLoading, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor(hex: 0x4A4A4A)]))
            }
            overLayView.addSubview(label)
            label.text = textLoading
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-40)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    func hideLoadingDotAds() {
        self.view.subviews.first(where: {$0.tag == -111})?.removeFromSuperview()
        self.view.subviews.first(where: {$0.tag == -112})?.removeFromSuperview()
    }
    
    var keyWindowAds: UIWindow? {
        get {
            return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
    }
}
