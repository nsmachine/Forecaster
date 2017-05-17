//
//  LocationViewModel.swift
//  Forecaster
//
//  Created by nsmachine on 5/20/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation

import ForecasterSDK

import RealmSwift

class LocationViewModel {
    
    func loadLocations() -> Results<Location>? {
        
        return ForecasterService().allLocations()
    }
    
    func deleteLocation(location: Location) {
        
        ForecasterService().deleteLocation(location: location)
    }
    
    func updateForecast() {
        
        ForecasterService().updateForecast()
    }
}
