//
//  MediumNativeAdView.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 25/02/2022.
//

import UIKit
import GoogleMobileAds

protocol NativeViewProtocol {
    func  bindingData(nativeAd: GADNativeAd)
}

class MediumNativeAdView: GADNativeAdView, NativeViewProtocol {
    
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var starNumberLabel: UILabel!
    
    func bindingData(nativeAd: GADNativeAd) {
        hideSkeleton()
        stopSkeletonAnimation()
        (headlineView as? UILabel)?.text = nativeAd.headline
        (callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        callToActionView?.isHidden = nativeAd.callToAction == nil
        callToActionView?.backgroundColor = AdMobManager.shared.backgroundButtonAdsNative
        (iconView as? UIImageView)?.image = nativeAd.icon?.image
        iconView?.isHidden = nativeAd.icon == nil
        
        mediaView?.isHidden = true
        
        if let star = nativeAd.starRating, let image = imageOfStars(from: star) {
            (starRatingView as? UIImageView)?.image = image
            starNumberLabel.text = "\(star)"
        } else {
            ratingStackView?.isHidden = true
        }
        
        (bodyView as? UILabel)?.text = nativeAd.body
        bodyView?.isHidden = nativeAd.body == nil
        
        (priceView as? UILabel)?.text = nativeAd.price
        priceView?.isHidden = nativeAd.price == nil
        
        (advertiserView as? UILabel)?.text = nativeAd.advertiser
        advertiserView?.isHidden = nativeAd.advertiser == nil
        
        backgroundColor = AdMobManager.shared.backgroundAdsNative
        
        self.nativeAd = nativeAd
    }
    
}
