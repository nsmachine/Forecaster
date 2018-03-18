//
//  Location.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import CoreLocation

import RealmSwift
import SwiftyJSON

public class Location: Object, ModelObject {
    
    @objc public private(set) dynamic var identifier = ""
    
    @objc public internal(set) dynamic var name: String = ""
    @objc public internal(set) dynamic var locality: String = ""
    @objc public internal(set) dynamic var subLocality: String = ""
    @objc public internal(set) dynamic var administrativeArea: String = ""
    @objc public internal(set) dynamic var subAdministrativeArea: String = ""
    @objc public internal(set) dynamic var country: String = ""
    @objc public internal(set) dynamic var isoCountryCode: String = ""
    
    @objc public internal(set) dynamic var latitude: Double = 0.0
    @objc public internal(set) dynamic var longitude: Double = 0.0
    @objc public internal(set) dynamic var radius: Double = 0.0
    
    @objc public internal(set) dynamic var timeZone: String = ""
    
    @objc public internal(set) dynamic var creationTimestamp: Double = 0.0
    @objc public internal(set) dynamic var lastUpdateTimestamp: Double = 0.0
    
    @objc public internal(set) dynamic var currently: Forecast?
    
    public internal(set) var hourly   = List<Forecast>()
    public internal(set) var daily    = List<Forecast>()
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public required convenience init(json: JSON) {
        
        self.init()
        
        mapFromJSON(json)
    }
    
    public required convenience init(placemark: CLPlacemark?) {
        
        self.init()
        
        guard let placemark = placemark else { return }
        
        creationTimestamp = Date().timeIntervalSince1970
        
        name = placemark.name ?? ""
        locality = placemark.locality ?? ""
        subLocality = placemark.subLocality ?? ""
        administrativeArea = placemark.administrativeArea ?? ""
        subAdministrativeArea = placemark.subAdministrativeArea ?? ""
        country = placemark.country ?? ""
        isoCountryCode = placemark.isoCountryCode ?? ""
        
        latitude = placemark.location?.coordinate.latitude ?? 0.0
        longitude = placemark.location?.coordinate.longitude ?? 0.0
        radius = (placemark.region as? CLCircularRegion)?.radius ?? 0.0
        
        timeZone = placemark.timeZone?.identifier ?? ""
        
        identifier = locality + " " + administrativeArea + " " + isoCountryCode
    }
}
