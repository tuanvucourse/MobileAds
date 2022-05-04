//
//  Unifiedself.swift
//  MobileAds
//
//  Created by macbook on 30/08/2021.
//

import UIKit
import GoogleMobileAds

class UnifiedNativeAdView: GADNativeAdView, NativeViewProtocol {

    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var numberRatingLabel: UILabel!
    @IBOutlet weak var adMediaView: GADMediaView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var advertiserLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    func bindingData(nativeAd: GADNativeAd) {
        self.hideSkeleton()
        headlineLabel.text = nativeAd.headline
        adMediaView.mediaContent = nativeAd.mediaContent

        bodyLabel.text = nativeAd.body
        bodyLabel.isHidden = nativeAd.body == nil
        actionButton.backgroundColor = AdMobManager.shared.backgroundButtonAdsNative
        actionButton.setTitle(nativeAd.callToAction, for: .normal)
        actionButton.isHidden = nativeAd.callToAction == nil
        
        thumbImageView.image = nativeAd.icon?.image
        thumbImageView.isHidden = nativeAd.icon == nil
        
        if let star = nativeAd.starRating, let image = imageOfStars(from: star) {
            starRatingImageView.image = image
            numberRatingLabel.text = "\(star)"
        } else {
            ratingView.isHidden = true
        }

        priceLabel.text = nativeAd.price
        priceLabel.isHidden = nativeAd.price == nil

        advertiserLabel.text = nativeAd.advertiser
        advertiserLabel.isHidden = nativeAd.advertiser == nil

        actionButton.isUserInteractionEnabled = false

        self.nativeAd = nativeAd
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: 0xE9E9E9).cgColor
    }

}
