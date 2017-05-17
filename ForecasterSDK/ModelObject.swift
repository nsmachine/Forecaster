//
//  ModelObject.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/17/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

protocol ModelObject {
    
    init()
    init(json: JSON)
    
    func mapFromJSON(_ json: JSON)
}

extension ModelObject {
    
    init(json: JSON) {
        
        self.init()
        
        mapFromJSON(json)
    }
    
    public func mapFromJSON(_ json: JSON) {
        
    }
}
