//
//  AdMobManager+Native.swift
//  MobileAds
//
//  Created by macbook on 29/08/2021.
//

import Foundation
import GoogleMobileAds
import SkeletonView

public enum OptionAdType {
    case option_1
    case option_2
}

public enum NativeAdType {
    case small
    case medium
    case unified(OptionAdType)
    
    var nibName: String {
        switch self {
        case .small:
            return "SmallNativeAdView"
        case .medium:
            return "MediumNativeAdView"
        case .unified(let option):
            switch option {
            case .option_1:
                return "UnifiedNativeAdView"
            case .option_2:
                return "UnifiedNativeAdView_2"
            }
            
        }
    }
}

// MARK: - GADUnifiedNativeAdView
extension AdMobManager {
   
    private func getNativeAdLoader(unitId: AdUnitID) -> GADAdLoader? {
        return listLoader.object(forKey: unitId.rawValue) as? GADAdLoader
    }

    private func getAdNative(unitId: String) -> GADNativeAdView? {
        if let adNativeView = listAd.object(forKey: unitId) as? GADNativeAdView  {
            return adNativeView
        }
        return nil
    }
    
    private func createAdNativeIfNeed(unitId: AdUnitID, type: NativeAdType = .small) -> GADNativeAdView? {
        if let adNativeView = getAdNative(unitId: unitId.rawValue) {
            return adNativeView
        }
        guard
            let nibObjects = Bundle.main.loadNibNamed(type.nibName, owner: nil, options: nil),
            let adNativeView = nibObjects.first as? GADNativeAdView else {
                return nil
            }
        listAd.setObject(adNativeView, forKey: unitId.rawValue as NSCopying)
        return adNativeView
    }
    
    private func reloadAdNative(unitId: AdUnitID) {
        if let loader = self.getNativeAdLoader(unitId: unitId) {
            loader.load(GADRequest())
        }
    }
    
    public func addAdNative(unitId: AdUnitID, rootVC: UIViewController, view: UIView, type: NativeAdType = .small) {
        self.removeAd(unitId: unitId.rawValue)
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
        adNativeView.layoutIfNeeded()
        adNativeView.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
        adNativeView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
        self.loadAdNative(unitId: unitId, rootVC: rootVC)
    }
    
    
    private func loadAdNative(unitId: AdUnitID, rootVC: UIViewController) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 1
        let adLoader = GADAdLoader(adUnitID: unitId.rawValue,
            rootViewController: rootVC,
            adTypes: [ .native ],
            options: [multipleAdsOptions])
        listLoader.setObject(adLoader, forKey: unitId.rawValue as NSCopying)
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
        } else if let nativeAdView = nativeAdView as? UnifiedNativeAdView_2 {
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
