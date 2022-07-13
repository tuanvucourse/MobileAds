//
//  RemoteConfigService.swift
//  EasyScanner
//
//  Created by Quang Ly Hoang on 14/03/2022.
//

import UIKit
import FirebaseRemoteConfig

public struct RemoteKey {
    public var rawValue: String = ""
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

open class RemoteConfigService {
    // MARK: - Singleton
    public static let shared = RemoteConfigService()
    public var isFetch: Bool = false
    
    // MARK: - init
    private init() {
        #if DEBUG
        settingForDebug()
        #endif
    }
    
    // MARK: - Functions
    private func settingForDebug() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
   public func fetchCloudValues(complete: @escaping BoolBlockAds) {
        RemoteConfig.remoteConfig().fetch { _, error in
            if error != nil {
                DispatchQueue.main.async {
                    complete(false)
                }
                return
            }
            
            RemoteConfig.remoteConfig().activate { _, _ in
                DispatchQueue.main.async {
                    self.isFetch = true
                    complete(true)
                }
            }
        }
    }
    
    public func loadDefaultValues(allKey: [RemoteKey], value: Any) {
        let defaults = Dictionary(uniqueKeysWithValues: allKey.map{ ($0.rawValue, value) })
        RemoteConfig.remoteConfig().setDefaults(defaults as? [String: NSObject])
    }
    
    public func number(forKey key: RemoteKey) -> Int {
        return RemoteConfig.remoteConfig()[key.rawValue].numberValue.intValue
    }
    
    public func bool(forKey key: RemoteKey) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    public func string(forKey key: RemoteKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    public func double(forKey key: RemoteKey) -> Double {
        return RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
    }
    
    public func objectJson<T: Decodable>(forKey key: RemoteKey, type: T.Type) -> T? {
        let data = RemoteConfig.remoteConfig()[key.rawValue].dataValue
        return try? JSONDecoder().decode(type, from: data)
    }
}
