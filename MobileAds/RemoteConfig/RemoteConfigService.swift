//
//  RemoteConfigService.swift
//  EasyScanner
//
//  Created by Quang Ly Hoang on 14/03/2022.
//

import UIKit
import Firebase

public enum RemoteKey<T>{
    case key(T)
}

open class RemoteConfigService {
    // MARK: - Singleton
    public static let shared = RemoteConfigService()
    
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
                    complete(true)
                }
            }
        }
    }
    
    public func bool(forKey key: RemoteKey<String>) -> Bool {
        switch key {
        case .key(let value):
           return RemoteConfig.remoteConfig()[value].boolValue
        }
        
    }
    
    public func string(forKey key: RemoteKey<String>) -> String {
        switch key {
        case .key(let value):
           return RemoteConfig.remoteConfig()[value].stringValue ?? ""
        }
    }
    
    public func double(forKey key: RemoteKey<String>) -> Double {
        switch key {
        case .key(let value):
           return RemoteConfig.remoteConfig()[value].numberValue.doubleValue
        }
        
    }
}
