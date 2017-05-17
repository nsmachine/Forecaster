//
//  WeatherCondition.swift
//  Forecaster
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import UIKit

import ForecasterSDK

extension WeatherCondition {
    
    enum IconStyle {
        
        case Day
        case Night
        case None
    }
    
    func icon(style: IconStyle) -> UIImage? {
        
        var suffix = ""
        
        switch style {
        case .Day:
            suffix = "-Sun"
        case .Night:
            suffix = "-Moon"
        case .None:
            suffix = ""
        }
        
        switch self {

        case .unknown:
            return nil
        case .clear:
            return UIImage(named: "Cloud\(suffix).svg.png")
        case .rain:
            return UIImage(named: "Cloud-Rain\(suffix).svg.png")
        case .snow:
            return UIImage(named: "Cloud-Snow\(suffix).svg.png")
        case .sleet:
            return UIImage(named: "Cloud-Snow\(suffix).svg.png")
        case .wind:
            return UIImage(named: "Cloud-Wind\(suffix).svg.png")
        case .fog:
            return UIImage(named: "Cloud-Fog\(suffix).svg.png")
        case .cloudy:
            return UIImage(named: "Cloud.svg.png")
        case .partlyCloudy:
            return UIImage(named: "Cloud\(suffix).svg.png")
        case .hail:
            return UIImage(named: "Cloud-Hail\(suffix).svg.png")
        case .thunderStorm:
            return UIImage(named: "Cloud-Lightning\(suffix).svg.png")
        case .tornado:
            return UIImage(named: "Tornado.svg.png")
        }
    }
}
