//
//  ForecasterService.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/20/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

public class ForecasterService {
    
    lazy var provider: ForecastProvider = forecastProvider(.DarkSky)
    
    @discardableResult
    public init() {
        
    }
    
    public func addLocationWithPlacemark(placemark: CLPlacemark?, completion: @escaping (_ error: Error?) -> Void) {
        
        guard let placemark = placemark else { return }
        
        let location = Location(placemark: placemark)
        
        ForecasterSDK.realmWriteQueue.async {
            
            if let realm = ForecasterSDK.realm {
                
                do {
                    try realm.write {
                        realm.add(location, update: true)
                    }
                    self.updateForecastForLocation(location, completion: completion)
                } catch {
                    
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }
    
    public func deleteLocation(location: Location) {
        
        let id = location.identifier
        
        ForecasterSDK.realmWriteQueue.async {
            
            if let realm = ForecasterSDK.realm {
                
                do {
                    try realm.write {
                        
                        if let object = realm.object(ofType: Location.self, forPrimaryKey: id) {
                            realm.delete(object)
                        }
                    }
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    public func allLocations() -> Results<Location>? {
        
        if let realm = ForecasterSDK.realm {
            
            return realm.objects(Location.self).sorted(byKeyPath: "creationTimestamp")
        } else {
            return nil
        }
    }
    
    public func updateForecast(completion: (() -> ())? = nil) {
        
        if let realm = ForecasterSDK.realm {
            
            let locations = realm.objects(Location.self)
            
            let group = DispatchGroup()
            
            locations.forEach({ (location) in
                
                group.enter()
                updateForecastForLocation(location, completion: { (error) in

                    group.leave()
                })
            })
            
            group.notify(queue: .main) {
                completion?()
            }
        }
    }
    
    public func updateForecastForLocation(_ location: Location, completion: @escaping (_ error: Error?) -> Void) {
        
        if Date().timeIntervalSince1970 - location.lastUpdateTimestamp < ForecasterSDK.forecastRefreshInterval {
            completion(nil)
            print("Skipping update forecast for Location: \(location.identifier)")
            return
        }
        
        let unmanagedObj = Location(value: location)
        
        let locationRef = ThreadSafeReference(to: location)
        
        print("Will update forecast for Location: \(unmanagedObj.identifier)")
        
        provider.updateForecastFor(location: unmanagedObj, completion: { (currently, hourly, daily, error) in
            
            guard error == nil
                else {
                    print("\(String(describing: error))")
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
            }
            
            ForecasterSDK.realmWriteQueue.async {
                
                if let realm = ForecasterSDK.realm {
                    
                    guard let resolvedLocation = realm.resolve(locationRef) else { return }
                    
                    print("Did update forecast for Location: \(resolvedLocation.identifier)")
                    do {
                        try realm.write {
                            
                            resolvedLocation.lastUpdateTimestamp = Date().timeIntervalSince1970
                            
                            resolvedLocation.currently = currently
                            
                            resolvedLocation.hourly.removeAll()
                            resolvedLocation.hourly.append(objectsIn: hourly)
                            
                            resolvedLocation.daily.removeAll()
                            resolvedLocation.daily.append(objectsIn: daily)
                            
                            realm.add(resolvedLocation, update: true)
                        }
                    } catch {
                        print("\(error)")
                    }
                }
                
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        })
    }
}
