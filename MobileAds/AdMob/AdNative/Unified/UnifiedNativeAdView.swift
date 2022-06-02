//
//  Unifiedself.swift
//  EasyVPN
//
//  Created by ANH VU on 03/12/2021.
//


import UIKit
import GoogleMobileAds
import SkeletonView

class UnifiedNativeAdView: GADNativeAdView {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var lblRateCount: UILabel!
    
    func bindingData(nativeAd: GADNativeAd) {
        self.hideSkeleton()
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent

        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            //videoStatusLabel.text = "Ad contains a video asset."
        } else {
            //videoStatusLabel.text = "Ad does not contain a video."
        }
        
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
//        bannerImageView.image = nativeAd.images?.first?.image
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        self.callToActionView?.layer.cornerRadius = AdMobManager.shared.nativeButtonCornerRadius
        self.callToActionView?.layer.backgroundColor = AdMobManager.shared.backgroundButtonAdsNative.cgColor
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil

        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.text = "\(nativeAd.starRating ?? 0)"
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil

        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil

        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadiusButton
        backgroundColor = AdMobManager.shared.backgroundAdsNative
        layer.borderWidth = AdMobManager.shared.adsNativeBorderWidth
        layer.borderColor = AdMobManager.shared.adsNativeBorderColor.cgColor
        layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadius
        clipsToBounds = true

        self.nativeAd = nativeAd
    }

}
