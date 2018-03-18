//
//  Forecast.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import CoreLocation

import RealmSwift
import SwiftyJSON

public class Forecast: Object, ModelObject {
    
    @objc public internal(set) dynamic var time: Double = 0.0
    
    @objc public internal(set) dynamic var summary: String = ""
    
    @objc public internal(set) dynamic var temperature: Float = 0.0
    @objc public internal(set) dynamic var feelsLike: Float = 0.0
    @objc public internal(set) dynamic var maxTemperature: Float = 0.0
    @objc public internal(set) dynamic var minTemperature: Float = 0.0
    
    @objc public internal(set) dynamic var dewPoint: Float = 0.0
    @objc public internal(set) dynamic var humidity: Float = 0.0
    
    @objc public internal(set) dynamic var rainProbablity: Float = 0.0
    
    @objc public internal(set) dynamic var windSpeed: Float = 0.0
    @objc public internal(set) dynamic var windBearing: Float = 0.0
    public var windDirection: WindDirection {
        return WindDirection(degrees: windBearing)
    }
    
    @objc public internal(set) dynamic var pressure: Float = 0.0
    
    @objc public internal(set) dynamic var visibility: Float = 0.0
    
    @objc public internal(set) dynamic var sunriseTime: Double = 0.0
    @objc public internal(set) dynamic var sunsetTime: Double = 0.0
    
    @objc public internal(set) dynamic var conditionRaw: String = ""
    public var condition: WeatherCondition {
        
        return WeatherCondition(condition: conditionRaw)
    }
    
    public required convenience init(json: JSON) {
        
        self.init()
        
        mapFromJSON(json)
    }
}
