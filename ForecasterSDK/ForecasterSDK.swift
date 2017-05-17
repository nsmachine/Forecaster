//
//  ForecasterSDK.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/17/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import RealmSwift

class ForecasterSDK {
    
    static let responseQueue = DispatchQueue(label: "com.forecasterSDK.responseQueue",
                                             qos: .userInitiated,
                                             attributes: DispatchQueue.Attributes.concurrent)
    
    static let realmWriteQueue = DispatchQueue(label: "com.forecasterSDK.realmWriteQueue",
                                               qos: .userInitiated)
    
    static var realm: Realm? {
        
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        var realm: Realm?
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            print(error)
        }
        
        return realm
    }
    
    static let forecastRefreshInterval: Double = 600
}
