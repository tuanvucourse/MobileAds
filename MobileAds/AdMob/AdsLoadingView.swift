//
//  AdsLoadingView.swift
//  MobileAds
//
//  Created by shjn on 29/06/2023.
//

import Foundation
import UIKit

class AdsLoadingView: UIView {
    private let loadingLabel: UILabel = {
        let lb = UILabel()
        lb.text = AdMobManager.shared.loadingAdsString
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = UIColor(hex: 0x4A4A4A)
        return lb
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    func setupUI() {
        self.backgroundColor = UIColor(hex: 0xC6C6C6)
        self.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
