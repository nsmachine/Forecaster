//
//  Units.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation

public enum Units {
    
    case US
    case SI
}

public extension Units {
    
    var forWindSpeed: String {
        
        switch self {
        case .US:
            return "MPH"
        case .SI:
            return "M/S"
        }
    }
    
    var forTemperature: String {
        
        switch self {
        case .US:
            return "F"
        case .SI:
            return "C"
        }
    }
    
    var forPressure: String {
        
        switch self {
        case .US:
            return "mBar"
        case .SI:
            return "hPa"
        }
    }
}
