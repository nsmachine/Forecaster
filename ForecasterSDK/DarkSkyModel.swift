//
//  DarkSkyModelExtensions.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DarkSkyModel: ModelObject {
    
    func mapFromJSON(_ json: JSON)
}

extension Forecast: DarkSkyModel {
    
    func mapFromJSON(_ json: JSON) {
        
        time            = json["time"].doubleValue
        
        summary         = json["summary"].stringValue
        
        temperature     = json["temperature"].floatValue
        feelsLike       = json["apparentTemperature"].floatValue
        maxTemperature  = json["temperatureMax"].floatValue
        minTemperature  = json["temperatureMin"].floatValue
        
        dewPoint        = json["dewPoint"].floatValue
        humidity        = json["humidity"].floatValue
        
        rainProbablity  = json["precipProbability"].floatValue
        
        windSpeed       = json["windSpeed"].floatValue
        windBearing     = json["windBearing"].floatValue
        
        pressure        = json["pressure"].floatValue
        
        visibility      = json["visibility"].floatValue
        
        sunriseTime     = json["sunriseTime"].doubleValue
        sunsetTime      = json["sunsetTime"].doubleValue
        
        conditionRaw    = json["icon"].stringValue
    }
}
