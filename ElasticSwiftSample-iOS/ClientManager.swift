//
//  ClientManager.swift
//  ElasticSwiftSample-iOS
//
//  Created by Prafull Kumar Soni on 3/11/18.
//  Copyright © 2018 pksprojects. All rights reserved.
//

import Foundation
import NotificationCenter
import ElasticSwift

class ClientManager {
    
    private var _client: RestClient? {
        didSet {
            NotificationCenter.default.post(name: AppNotifications.connectionUpdated, object: _client)
        }
    }
    
    init() {
        self.connect(host: "192.168.1.100", port: 9200, username: "elastic", password: "elastic")
    }
    
    public var client: RestClient {
        get {
            return _client!
        }
    }
    
    public func connect(host: String, port: Int, username: String, password: String) {
        
        let certPath = Bundle.main.path(forResource: "elastic-certificates", ofType: "der")
        let sslConfig =  SSLConfiguration(certPath: certPath!, isSelf: true)
        let cred = ClientCredential(username: username, password: password)
        var component = URLComponents()
        var host = host
        if(host.starts(with: "https://")) {
            host = host.replacingOccurrences(of: "https://", with: "")
        }
        component.host =  host
        component.port = port
        component.scheme = "https"
        let url = component.url
        let settings = Settings(forHosts: [(url?.absoluteString)!], withCredentials: cred, withSSL: true, sslConfig: sslConfig)
        
        _client = RestClient(settings: settings)
        
    }
}
