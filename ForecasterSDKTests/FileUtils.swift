//
//  FileUtils.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/18/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import SwiftyJSON

func jsonFromFile(_ file: String, ofType type: String) -> JSON? {
    
    guard let data = dataFromFile(file, ofType: type)
        else {
            return nil
    }
    
    return JSON(data: data)
}

func dataFromFile(_ file: String, ofType type: String) -> Data? {
    
    guard let path = Bundle.main.path(forResource: file, ofType: type)
        else {
            return nil
    }
    
    guard let jsonString = try? String(contentsOfFile: path)
        else {
            return nil
    }
    
    guard let data = jsonString.data(using: .utf8, allowLossyConversion: false)
        else {
            return nil
    }
    
    return data
}

