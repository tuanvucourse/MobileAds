//
//  AdMobManager+Interstitial.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 22/02/2022.
//

import Foundation
import GoogleMobileAds

// MARK: - GADInterstitial
extension AdMobManager: GADFullScreenContentDelegate {
    
   func getAdInterstitial(unitId: String) -> GADInterstitialAd? {
        if let interstitial = listAd.object(forKey: unitId) as? GADInterstitialAd {
            return interstitial
        }
        return nil
    }
    
    /// khởi tạo id ads trước khi show
    public func createAdInterstitialIfNeed(unitId: String) {
        if self.getAdInterstitial(unitId: unitId) != nil {
            return
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: unitId,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                
                self.removeAd(unitId: unitId)
                self.blockFullScreenAdFaild?(unitId)
                self.blockCompletionHandeler?(false)
                return
            }
            
            guard let ad = ad else {
                self.removeAd(unitId: unitId)
                self.blockFullScreenAdFaild?(unitId)
                self.blockCompletionHandeler?(false)
                return
            }
            ad.fullScreenContentDelegate = self
            ad.paidEventHandler = { value in
                self.trackAdRevenue(value: value)
            }
            self.listAd.setObject(ad, forKey: unitId as NSCopying)
            self.blockLoadFullScreenAdSuccess?(unitId)
        }
        )
    }
    
    /// show ads Interstitial
    public func presentAdInterstitial(unitId: String) {
        self.createAdInterstitialIfNeed(unitId: unitId)
        let interstitial = self.getAdInterstitial(unitId: unitId)
        if let topVC =  UIApplication.getTopViewController() {
            interstitial?.present(fromRootViewController: topVC)
            AdResumeManager.shared.isShowingAd = true // check nếu show inter thig ko show réume
        }
    }
    
    public func showIntertitial(unitId: String) {
        if AdMobManager.shared.getAdInterstitial(unitId: unitId) != nil {
            guard let rootVC = UIApplication.getTopViewController() else {
                return
            }
            let loadingVC = AdFullScreenLoadingVC.createViewController(unitId: unitId, adType: .interstitial(id: unitId))
            rootVC.addChild(loadingVC)
            rootVC.view.addSubview(loadingVC.view)
            loadingVC.blockDidDismiss = {
                loadingVC.view.removeFromSuperview()
                loadingVC.removeFromParent()
            }
            loadingVC.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    // MARK: - GADInterstitialDelegate
    
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.blockFullScreenAdWillDismiss?()
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        self.blockFullScreenAdFaild?("")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    private func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
        blockCompletionHandeler?(true)
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        blockFullScreenAdDidDismiss?()
        print("Ad did dismiss full screen content.")
    }
    
}
