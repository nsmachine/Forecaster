//
//  DarkSkyAPIConfig.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/17/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

struct DarkSkyAPIConfig: RequestConfiguration {
    
    var host: String = "https://api.darksky.net"
    var path: String = ""
    var method: Alamofire.HTTPMethod = .get
    var customHeaders: [String : String] = [:]
    var parameters: [(Alamofire.ParameterEncoding, [String : CustomStringConvertible])] = []
    
    var apiSecret = "90f9cbcf2f4ba2502e0b80552ee05ccb"
    
    init(for api: DarkSkyAPI) {
        
        switch api {
        case .ForecastForLocation(let latitude, let longitude):
            configureForForecastForLocation(latitude: latitude, longitude: longitude)
        }
    }
}

extension DarkSkyAPIConfig {
    
    mutating func configureForForecastForLocation(latitude: Double, longitude: Double) {
        
        // "/forecast/90f9cbcf2f4ba2502e0b80552ee05ccb/37.8267,-122.4233?exclude=value1,value2"
        path = "/forecast/\(apiSecret)/\(latitude),\(longitude)"
        method = .get
        
        parameters.append((URLEncoding(destination: .queryString), ["exclude" : "minutely",
                                                                    "units" : "us"]))
    }
}
