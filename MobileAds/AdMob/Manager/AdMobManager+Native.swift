//
//  AdMobManager+Native.swift
//  MobileAds
//
//  Created by macbook on 29/08/2021.
//

import Foundation
import GoogleMobileAds

public enum NativeAdType {
    case small
    case medium
    case unified
    
    var nibName: String {
        switch self {
        case .small:
            return "SmallNativeAdView"
        case .medium:
            return "MediumNativeAdView"
        case .unified:
            return "UnifiedNativeAdView"
        }
    }
}

// MARK: - GADUnifiedNativeAdView
extension AdMobManager {
   
    private func getNativeAdLoader(unitId: String) -> GADAdLoader? {
        return listLoader.object(forKey: unitId) as? GADAdLoader
    }

    private func getAdNative(unitId: String) -> GADNativeAdView? {
        if let adNativeView = listAd.object(forKey: unitId) as? GADNativeAdView  {
            return adNativeView
        }
        return nil
    }
    
    private func createAdNativeIfNeed(unitId: String, type: NativeAdType = .small) -> GADNativeAdView? {
        if let adNativeView = getAdNative(unitId: unitId) {
            return adNativeView
        }
        guard
            let nibObjects = Bundle.main.loadNibNamed(type.nibName, owner: nil, options: nil),
            let adNativeView = nibObjects.first as? GADNativeAdView else {
                return nil
            }
        listAd.setObject(adNativeView, forKey: unitId as NSCopying)
        return adNativeView
    }
    
    private func reloadAdNative(unitId: String) {
        if let loader = self.getNativeAdLoader(unitId: unitId) {
            loader.load(GADRequest())
        }
    }
    
    public func addAdNative(unitId: String, rootVC: UIViewController, view: UIView, type: NativeAdType = .small) {
        guard let adNativeView = self.createAdNativeIfNeed(unitId: unitId, type: type) else {
            return
        }
        
        adNativeView.tag = 2525

        if let unitData = listAd[unitId] as? GADNativeAdView, let ad = unitData.nativeAd, let adNative = adNativeView as? NativeViewProtocol {
            adNative.bindingData(nativeAd: ad)

            if let viewWithTag = view.viewWithTag(2525) {
                viewWithTag.removeFromSuperview()
            }
            view.addSubview(adNativeView)

            adNativeView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return
        }
        
        view.addSubview(adNativeView)
        adNativeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        adNativeView.isSkeletonable = true
        adNativeView.showAnimatedGradientSkeleton()
        self.loadAdNative(unitId: unitId, rootVC: rootVC)
    }
    
    
    private func loadAdNative(unitId: String, rootVC: UIViewController) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5
        let adLoader = GADAdLoader(adUnitID: unitId,
            rootViewController: rootVC,
            adTypes: [ .native ],
            options: [multipleAdsOptions])
        listLoader.setObject(adLoader, forKey: unitId as NSCopying)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

// MARK: - GADUnifiedNativeAdDelegate
extension AdMobManager: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordClick ")
    }
}

// MARK: - GADAdLoaderDelegate
extension AdMobManager: GADAdLoaderDelegate {
    
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        self.blockNativeFaild?(adLoader.adUnitID)
        self.removeAd(unitId: adLoader.adUnitID)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("ad==> adLoaderDidFinishLoading \(adLoader)")
    }
}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension AdMobManager: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        nativeAd.paidEventHandler = { value in
            self.trackAdRevenue(value: value)
        }
        guard let nativeAdView = self.getAdNative(unitId: adLoader.adUnitID) else {return}
        nativeAd.mediaContent.videoController.delegate = self
        if let nativeAdView = nativeAdView as? UnifiedNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        } else if let nativeAdView = nativeAdView as? SmallNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        } else if let nativeAdView = nativeAdView as? MediumNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        }
    }
    
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordImpression")
    }
    
}

// MARK: - GADVideoControllerDelegate
extension AdMobManager: GADVideoControllerDelegate {
    
}
