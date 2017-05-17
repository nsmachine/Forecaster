//: Playground - noun: a place where people can play

import UIKit
import ForecasterSDK
import MapKit
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

class Completer: NSObject, MKLocalSearchCompleterDelegate {
    
    let completer = MKLocalSearchCompleter()
    var query = ""
    
    override init() {
        super.init()
        completer.delegate = self
        completer.filterType = .locationsOnly
    }
    
    func complete(string: String) {
        if completer.isSearching {
            return
        }
        query = string
        completer.queryFragment = string
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let results = completer.results.filter{ [weak self] in $0.title.localizedCaseInsensitiveContains(self?.query ?? "") }
        
        for location in results {
            
            print("\(location.title) ** \(location.subtitle)")
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        print("\(error)")
    }

}

//let completer = Completer()
//completer.complete(string: "Ancho")
