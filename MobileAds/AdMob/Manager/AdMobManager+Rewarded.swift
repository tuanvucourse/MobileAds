//
//  AdMobManager+Rewarded.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 22/02/2022.
//

import Foundation
import GoogleMobileAds

// MARK: - GADInterstitial
extension AdMobManager {
    
    func getAdRewarded(unitId: String) -> GADRewardedAd? {
        if let rewarded = listAd.object(forKey: unitId) as? GADRewardedAd {
            return rewarded
        }
        return nil
    }
    
    /// khởi tạo id ads trước khi show
    public func createAdRewardedIfNeed(unitId: String) {
        if self.getAdRewarded(unitId: unitId) != nil {
            return
        }
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: unitId, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                
                self?.removeAd(unitId: unitId)
                self?.blockFullScreenAdFaild?(unitId)
                self?.blockCompletionHandeler?(false)
                return
            }
            
            guard let ad = ad else {
                self?.removeAd(unitId: unitId)
                self?.blockFullScreenAdFaild?(unitId)
                self?.blockCompletionHandeler?(false)
                return
            }
            ad.fullScreenContentDelegate = self
            ad.paidEventHandler = { value in
                self?.trackAdRevenue(value: value)
            }
            self?.listAd.setObject(ad, forKey: unitId as NSCopying)
            self?.blockLoadFullScreenAdSuccess?(unitId)
        }
    }
    
    public func presentAdRewarded(unitId: String) {
        createAdRewardedIfNeed(unitId: unitId)
        let rewarded = getAdRewarded(unitId: unitId)
        didEarnReward = false
        if let topVC =  UIApplication.getTopViewController() {
            rewarded?.present(fromRootViewController: topVC) { [weak self] in
                self?.didEarnReward = true
            }
            AdResumeManager.shared.isShowingAd = true // check nếu show rewarded thig ko show resume
        }
    }
    
    public func showRewarded(unitId: String, completion: BoolBlockAds?) {
        if AdMobManager.shared.getAdRewarded(unitId: unitId) != nil {
            guard let rootVC = UIApplication.getTopViewController() else {
                return
            }
            let loadingVC = AdFullScreenLoadingVC.createViewController(unitId: unitId, adType: .reward(id: unitId))
            rootVC.addChild(loadingVC)
            rootVC.view.addSubview(loadingVC.view)
            loadingVC.blockDidDismiss = { [weak loadingVC] in
                loadingVC?.view.removeFromSuperview()
                loadingVC?.removeFromParent()
                completion?(self.didEarnReward)
            }
            loadingVC.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
}
