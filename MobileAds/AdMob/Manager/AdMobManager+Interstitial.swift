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

    /// khởi tạo id ads trước khi show
    public func createAdInterstitialIfNeed(unitId: AdUnitID, completion: BoolBlockAds? = nil) {
        if self.getAdInterstitial(unitId: unitId) != nil {
            return
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: unitId.rawValue,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                
                self.removeAd(unitId: unitId.rawValue)
                self.blockFullScreenAdFaild?(unitId.rawValue)
                self.blockCompletionHandeler?(false)
                completion?(false)
                return
            }
            
            guard let ad = ad else {
                self.removeAd(unitId: unitId.rawValue)
                self.blockFullScreenAdFaild?(unitId.rawValue)
                self.blockCompletionHandeler?(false)
                completion?(false)
                return
            }
            ad.fullScreenContentDelegate = self
            ad.paidEventHandler = { value in
                self.trackAdRevenue(value: value)
            }
            self.listAd.setObject(ad, forKey: unitId.rawValue as NSCopying)
            self.blockLoadFullScreenAdSuccess?(unitId.rawValue)
            completion?(true)
        })
    }
    
    func getAdInterstitial(unitId: AdUnitID) -> GADInterstitialAd? {
        if let interstitial = listAd.object(forKey: unitId.rawValue) as? GADInterstitialAd {
             return interstitial
         }
         return nil
     }
    
    /// show ads Interstitial
    func presentAdInterstitial(unitId: AdUnitID) {
        self.createAdInterstitialIfNeed(unitId: unitId)
        let interstitial = self.getAdInterstitial(unitId: unitId)
        if let topVC =  UIApplication.getTopViewController() {
            interstitial?.present(fromRootViewController: topVC)
            AdResumeManager.shared.isShowingAd = true // check nếu show inter thig ko show réume
        }
    }
    
    public func showIntertitial(unitId: AdUnitID, isSplash: Bool = false, blockWillDismiss: VoidBlockAds? = nil) {
        if isSplash {
            createAdInterstitialIfNeed(unitId: unitId) { [weak self] result in
                if result {
                    self?.isSplash = true
                    self?.showIntertitial(unitId: unitId, blockWillDismiss: blockWillDismiss)
                } else {
                    blockWillDismiss?()
                }
            }
           return
        }
        
        if AdMobManager.shared.getAdInterstitial(unitId: unitId) != nil {
            var rootVC = UIApplication.getTopViewController()
            if rootVC?.navigationController != nil {
                rootVC = rootVC?.navigationController
                if rootVC?.tabBarController != nil {
                    rootVC = rootVC?.tabBarController
                }
            }
            guard let rootVC = rootVC else { return }

            let loadingVC = AdFullScreenLoadingVC.createViewController(unitId: unitId, adType: .interstitial(id: unitId))
            rootVC.addChild(loadingVC)
            rootVC.view.addSubview(loadingVC.view)
            loadingVC.blockDidDismiss = { [weak loadingVC] in
                loadingVC?.view.removeFromSuperview()
                loadingVC?.removeFromParent()
                self.isSplash = false
            }
            loadingVC.blockWillDismiss = blockWillDismiss
            loadingVC.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            createAdInterstitialIfNeed(unitId: unitId)
            blockWillDismiss?()
        }
    }
    
    // MARK: - GADInterstitialDelegate
    
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.blockFullScreenAdWillDismiss?()
        AdResumeManager.shared.isShowingAd = false
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        self.blockFullScreenAdFaild?("")
        AdResumeManager.shared.isShowingAd = false
    }
    
    /// Tells the delegate that the ad presented full screen content.
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
        blockCompletionHandeler?(true)
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        blockFullScreenAdDidDismiss?()
        AdResumeManager.shared.isShowingAd = false
        print("Ad did dismiss full screen content.")
    }
    
}
