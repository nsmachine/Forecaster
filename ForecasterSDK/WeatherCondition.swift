//
//  WeatherCondition.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation

public enum WeatherCondition: String {
    
    case unknown        = "-"
    case clear          = "Clear"
    case rain           = "Rain"
    case snow           = "Snow"
    case sleet          = "Sleet"
    case wind           = "Windy"
    case fog            = "Fog"
    case cloudy         = "Cloudy"
    case partlyCloudy   = "Partly Cloudy"
    case hail           = "Hail"
    case thunderStorm   = "Thunder Storm"
    case tornado        = "Tornado"
    
    init(condition: String) {
        
        let cond = condition.components(separatedBy: CharacterSet.letters.inverted ).joined(separator: "").lowercased()
        
        switch cond {
        case "clear", "clearnight", "clearday":
            self = .clear
        case "rain", "showers", "lightrain":
            self = .rain
        case "snow", "snowy":
            self = .snow
        case "sleet":
            self = .sleet
        case "wind", "windy":
            self = .wind
        case "fog":
            self = .fog
        case "cloudy":
            self = .cloudy
        case "partlycloudy", "partlycloudynight", "partlycloudyday":
            self = .partlyCloudy
        case "hail":
            self = .hail
        case "thunderstorm":
            self = .thunderStorm
        case "tornado":
            self = .tornado
        default:
            self = .unknown
        }
    }
}


