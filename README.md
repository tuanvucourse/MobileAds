<img src="" alt="" />

# MobileAds
MobileAds is a Swift framework, a simple Ads engine that supports the google professional extension SDK

## Requirements

- iOS 12.0+
- Xcode 12.0+
- Swift 4.0+

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

To integrate MobileAds into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod 'MobileAds', :git => "git@github.com:AperoVN/MobileAds.git", :tag => '1.0.19'
```
New version:

```
pod 'MobileAds', :git => "git@github.com:AperoVN/MobileAds.git"
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Quick Start

Id ads Test:

```
public struct SampleAdUnitID {
    public static let adFormatAppOpen              = "ca-app-pub-3940256099942544/3419835294"
    public static let adFormatBanner               = "ca-app-pub-3940256099942544/6300978111"
    public static let adFormatInterstitial         = "ca-app-pub-3940256099942544/1033173712"
    public static let adFormatInterstitialVideo    = "ca-app-pub-3940256099942544/8691691433"
    public static let adFormatRewarded             = "ca-app-pub-3940256099942544/5224354917"
    public static let adFormatRewardedInterstitial = "ca-app-pub-3940256099942544/5354046379"
    public static let adFormatNativeAdvanced       = "ca-app-pub-3940256099942544/2247696110"
    public static let adFormatNativeAdvancedVideo  = "ca-app-pub-3940256099942544/1044960115"
}
```

```swift
import MobileAds

class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
```
## License

MobileAds is released under the MIT license. See LICENSE for details.
