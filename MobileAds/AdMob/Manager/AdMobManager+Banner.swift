//
//  AdMobManager+Banner.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 22/02/2022.
//

import Foundation
import GoogleMobileAds

// MARK: - GADBannerView
extension AdMobManager: GADBannerViewDelegate {
    
   fileprivate func getAdBannerView(unitId: String) -> GADBannerView? {
        if let interstitial = listAd.object(forKey: unitId) as? GADBannerView  {
            return interstitial
        }
        return nil
    }
    
   public func createAdBannerIfNeed(unitId: String) -> GADBannerView {
        if let adBannerView = self.getAdBannerView(unitId: unitId) {
            return adBannerView
        }
        let adBannerView = GADBannerView()
        adBannerView.adUnitID = unitId
        adBannerView.paidEventHandler = { value in
            self.trackAdRevenue(value: value)
        }
        listAd.setObject(adBannerView, forKey: unitId as NSCopying)
        return adBannerView
    }
    
    // quảng cáo xác định kích thước
    public func addAdBanner(unitId: String, rootVC: UIViewController, view: UIView) {
        let adBannerView = self.createAdBannerIfNeed(unitId: unitId)
        adBannerView.rootViewController = rootVC
        view.addSubview(adBannerView)
        adBannerView.delegate = self
        adBannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if view.isSkeletonable == false {
            adBannerView.isSkeletonable = true
            adBannerView.showAnimatedGradientSkeleton()
        }
        //adBannerView.adSize = GADAdSizeFromCGSize(view.bounds.size)
        let request = GADRequest()
        adBannerView.load(request)
    }
    
    // quảng có thích ứng với chiều cao không cố định
    public func addAdBannerAdaptive(unitId: String, rootVC: UIViewController, view: UIView) {
        let adBannerView = self.createAdBannerIfNeed(unitId: unitId)
        adBannerView.rootViewController = rootVC
        view.addSubview(adBannerView)
        adBannerView.delegate = self
        
        adBannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if view.isSkeletonable == false {
            adBannerView.isSkeletonable = true
            adBannerView.showAnimatedGradientSkeleton()
        }
        
        adBannerView.adSize =  GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(screenWidthAds)
        let request = GADRequest()
        adBannerView.load(request)
    }
    
    // MARK: - GADBanner delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad==> bannerView did load \(bannerView.adUnitID ?? "")")
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("ad==> bannerView faild \(error.localizedDescription)")
        if let unitId = bannerView.adUnitID {
            self.removeAd(unitId: unitId)
        }
        self.blockBannerFaild?(error.localizedDescription)
    }
    
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        if let adUnitID = bannerView.adUnitID {
            self.removeAd(unitId: adUnitID)
        }
    }
    
    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("ad==> adViewDidRecordImpression bannerView\(bannerView.adUnitID ?? "")")
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
        blockLoadBannerSuccess?(true)
    }
    
}
