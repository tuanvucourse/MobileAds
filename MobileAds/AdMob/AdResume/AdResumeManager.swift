//
//  AdResumeManager.swift
//  MobileAds
//
//  Created by ANH VU on 21/01/2022.
//

import Foundation
import GoogleMobileAds

// NOTE: Appdelegate : gọi loadAd()

//func applicationDidBecomeActive(_ application: UIApplication) {
//    if let rootView = UIApplication.getTopViewController() {
//        AdResumeManager.shared.showAdIfAvailable(viewController: rootView)
//    }
//}

protocol AdResumeManagerDelegate: AnyObject {
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AdResumeManager)
    
}

class AdResumeManager: NSObject {
    static let shared = AdResumeManager()
    
    let timeoutInterval: TimeInterval = 4 * 3600
    var appOpenAd: GADAppOpenAd?
    weak var appOpenAdManagerDelegate: AdResumeManagerDelegate?
    var isLoadingAd = false
    var isShowingAd = false
    var loadTime: Date?
    
    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }
    
    private func appOpenAdManagerAdDidComplete() {
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
    }
    
    func loadAd() {
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        GADAppOpenAd.load(withAdUnitID: "", request: GADRequest(), orientation: .portrait) { ad, error in
            self.isLoadingAd = false
            if let error = error {
                self.appOpenAd = nil
                self.loadTime = nil
                print("App open ad failed to load with error: \(error.localizedDescription).")
                return
            }
            
            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            print("App open ad loaded successfully.")
        }
    }
    
    func showAdIfAvailable(viewController: UIViewController) {
        if isShowingAd {
            print("App open ad is already showing.")
            return
        }
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            appOpenAdManagerAdDidComplete()
            loadAd()
            return
        }
        if let ad = appOpenAd {
            print("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: viewController)
        }
    }
}

extension AdResumeManager: GADFullScreenContentDelegate {
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error.localizedDescription).")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
}

