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
        //self.mediaView?.mediaContent = nativeAd.mediaContent
        
//        let mediaContent = nativeAd.mediaContent
//        if mediaContent.hasVideoContent {
            //videoStatusLabel.text = "Ad contains a video asset."
        //} else {
            //videoStatusLabel.text = "Ad does not contain a video."
        //}

        // ratio of the media it displays.
        //      if let mediaView = self.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
        //        heightConstraint = NSLayoutConstraint(
        //          item: mediaView,
        //          attribute: .height,
        //          relatedBy: .equal,
        //          toItem: mediaView,
        //          attribute: .width,
        //          multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
        //          constant: 0)
        //        heightConstraint?.isActive = true
        //      }
        
//        (self.bodyView as? UILabel)?.text = nativeAd.body
//        self.bodyView?.isHidden = nativeAd.body == nil
        
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil
        
        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil
        self.callToActionView?.backgroundColor = AdMobManager.shared.backgroundButtonAdsNative
//        (self.storeView as? UILabel)?.text = nativeAd.store
//        self.storeView?.isHidden = nativeAd.store == nil
        
//        (self.priceView as? UILabel)?.text = nativeAd.price
//        self.priceView?.isHidden = nativeAd.price == nil
    
        if nativeAd.price == nil || nativeAd.price == "" {
            self.viewLinePrice.isHidden = true
        } else {
            self.viewLinePrice.isHidden = false
        }
//
//        if self.viewLinePrice.isHidden, nativeAd.store == nil || nativeAd.store == "" {
//            stackAppStore.isHidden = true
//        } else {
//            stackAppStore.isHidden = false
//        }

        
        if nativeAd.advertiser == nil {
            (self.advertiserView as? UILabel)?.text = nativeAd.body
        } else {
            (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        }
//        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.isUserInteractionEnabled = false
        
        self.nativeAd = nativeAd
        
    }

}
