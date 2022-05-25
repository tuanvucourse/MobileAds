//
//  SmallNativeAdView.swift
//  MobileAds
//
//  Created by macbook on 30/08/2021.
//

import UIKit
import GoogleMobileAds
import SkeletonView

class SmallNativeAdView: GADNativeAdView, NativeViewProtocol {
    
    @IBOutlet weak var viewLinePrice: UIView!
    @IBOutlet weak var stackAppStore: UIStackView!
    
    func bindingData(nativeAd: GADNativeAd) {
        self.hideSkeleton()
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil
        
        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil
        self.callToActionView?.backgroundColor = AdMobManager.shared.backgroundButtonAdsNative
    
        if nativeAd.price == nil || nativeAd.price == "" {
            self.viewLinePrice.isHidden = true
        } else {
            self.viewLinePrice.isHidden = false
        }
        
        if nativeAd.advertiser == nil {
            (self.advertiserView as? UILabel)?.text = nativeAd.body
        } else {
            (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        }
        
        backgroundColor = AdMobManager.shared.backgroundAdsNative
        layer.borderWidth = AdMobManager.shared.adsNativeBorderWidth
        layer.borderColor = AdMobManager.shared.adsNativeBorderColor.cgColor
        layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadius
        clipsToBounds = true
        
        self.nativeAd = nativeAd
        
    }

}
