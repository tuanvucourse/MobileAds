//
//  AdsManager.swift
//  MobileAds
//
//  Created by ANH VU on 16/03/2022.
//

import Foundation
import UIKit

public class TestManager {
   public static let shared = TestManager()
    
    public func showTest(in vc: UIViewController) {
        let bundel = Bundle.init(for: TestViewController.self)
        let testVc = TestViewController(nibName: "TestViewController", bundle: bundel)
        vc.present(testVc, animated: true, completion: nil)
    }
    
    public func getMess() {
        print("create a framework demo")
        let image = UIImage(named: "ic_test", in: Bundle(for: type(of: self)), compatibleWith: nil)
        print(image)
    }
}
