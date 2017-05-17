//
//  ForecastProvider.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import CoreLocation

public enum ForecastProviderType {
    case DarkSky
}

func forecastProvider(_ type: ForecastProviderType) -> ForecastProvider {
    
    var source: ForecastProvider
    
    switch type {
    case .DarkSky:
        source = DarkSkyAPIClient()
    }
    
    return source
}

protocol ForecastProvider {
    
    typealias ForecastForLocationCompletion = (_ currently: Forecast?, _ hourly: [Forecast], _ daily: [Forecast], _ error: Error?) -> Void
    
    func updateForecastFor(location: Location, completion: @escaping ForecastForLocationCompletion)
}
