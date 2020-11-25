//
//  ContentViewModel.swift
//  FB-ABTest
//
//  Created by Jinwoo Kim on 11/26/20.
//

import Foundation
import Combine
import Firebase
import ObjectMapper

final class ContentViewModel: ObservableObject {
    @Published var receivedValue: String? = nil
    
    private struct Const {
        static let DefaultsName: String = "RemoteConfigDefaults"
        static let LogName: String = "log_event_test"
        static let RemoteConfigEventName: String = "retmoteconfig_event_test"
        static let ABTestEventName: String = "abtest_event_test"
    }
    
    private var remoteConfig: RemoteConfig!
    
    func configure() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: Const.DefaultsName)
    }
    
    func sendLog() {
        let value = receivedValue ?? "nil"
        let parameter = ["value": value] as [String: Any]
        Analytics.logEvent(Const.LogName, parameters: parameter)
    }
    
    func fetchRemoteConfigEvent() {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { [weak self] (status, error) in
            if status == .success {
                self?.remoteConfig?.activate { (changed, error) in
                    DispatchQueue.main.async {
                        self?.updateValue(event: Const.RemoteConfigEventName)
                    }
                }
            } else if let error = error {
                self?.receivedValue = "error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchABTestEvent() {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { [weak self] (status, error) in
            if status == .success {
                self?.remoteConfig?.activate { (changed, error) in
                    DispatchQueue.main.async {
                        self?.updateValue(event: Const.ABTestEventName)
                    }
                }
            } else if let error = error {
                self?.receivedValue = "error: \(error.localizedDescription)"
            }
        }
    }
    
    private func updateValue(event: String) {
        guard let data = remoteConfig.configValue(forKey: event).jsonValue else {
            receivedValue = "(data is nil!)"
            return
        }
        
        guard let object = Mapper<EventTestObject>().map(JSONObject: data) else {
            receivedValue = "(object is nil!)"
            return
        }
        
        receivedValue = object.value
    }
}
