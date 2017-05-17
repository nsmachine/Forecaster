//
//  AddLocationViewModel.swift
//  Forecaster
//
//  Created by nsmachine on 5/20/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

import RxSwift

import ForecasterSDK

class AddLocationViewModel: NSObject, MKLocalSearchCompleterDelegate {
    
    var queryResults: [String : [MKLocalSearchCompletion]] = [:]
    var searchCompleters: [MKLocalSearchCompleter] = []
    
    var currentQuery = ""
    
    let searchPublisher = PublishSubject<[MKLocalSearchCompletion]>()
    
    var queryTask: DispatchWorkItem?
    
    var geoCoder: CLGeocoder?
    
    var service: ForecasterService?
    
    override init() {
        super.init()
    }
    
    deinit {
        queryTask?.cancel()
    }
    
    func searchForLocationUsing(query: String) {
        
        queryTask?.cancel()
        
        if let results = queryResults[query] {
            searchPublisher.onNext(results)
            return
        }
        
        guard query.characters.count > 0
            else {
                currentQuery = ""
                searchPublisher.onNext([])
                return
        }
        
        let task = DispatchWorkItem { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.currentQuery = query
            
            let completer = MKLocalSearchCompleter()
            completer.delegate = self
            completer.filterType = .locationsOnly
            completer.queryFragment = query
            
            strongSelf.searchCompleters.append(completer)
        }
        
        queryTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: task)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let results = completer.results.filter{ $0.title.localizedCaseInsensitiveContains(completer.queryFragment) }
        
        queryResults[completer.queryFragment] = results
        
        if completer.queryFragment == currentQuery {
            //Publish
            searchPublisher.onNext(results)
        } else {
            //No op
        }
        
        if let index = searchCompleters.index(of: completer) {
            searchCompleters.remove(at: index)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        print("\(error)")
        
        if let index = searchCompleters.index(of: completer) {
            searchCompleters.remove(at: index)
        }
    }
    
    func addToUserLocations(address: String, completion: @escaping () -> Void) {
        
        geoCoder?.cancelGeocode()
        
        geoCoder = CLGeocoder()
        
        geoCoder?.geocodeAddressString(address) { [weak self] (placemarks, error) in
            
            self?.service = ForecasterService()
            self?.service?.addLocationWithPlacemark(placemark: placemarks?.first) { error in
                
                completion()
            }
        }
    }
}
