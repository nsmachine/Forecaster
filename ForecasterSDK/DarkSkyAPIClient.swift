//
//  DarkSkyAPIClient.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/17/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DarkSkyAPI {
    
    case ForecastForLocation(latitude: Double, longitude: Double)
}

class DarkSkyAPIClient: ForecastProvider {
    
    init() {
        
    }
    
    deinit {
        
    }
    
    func updateForecastFor(location: Location, completion: @escaping ForecastForLocationCompletion) {
        
        let config = DarkSkyAPIConfig(for: .ForecastForLocation(latitude: location.latitude, longitude: location.longitude))

        let request = Request(config: config)
        request.completion({ (data, error) in
            
            if let error = error {
                
                print("\(error)")
                
                completion(nil, [], [], error)
                
            } else if let data = data {
                
                let json = JSON(data)
                
                //Currently
                let currently = Forecast(json: json["currently"])
                
                //Hourly
                var hourly: [Forecast] = []
                
                let hourlyJSON = json["hourly"]["data"]
                
                hourlyJSON.forEach { (key, json) in
                    
                    let hourlyForecast = Forecast(json: json)
                    hourly.append(hourlyForecast)
                }
                
                //Daily
                var daily: [Forecast] = []
                
                let dailyJSON = json["daily"]["data"]
                
                dailyJSON.forEach { (key, json) in
                    
                    let dailyForecast = Forecast(json: json)
                    daily.append(dailyForecast)
                }
                
                //Completions
                completion(currently, hourly, daily, nil)
            }
        })
        request.start()
    }
}
