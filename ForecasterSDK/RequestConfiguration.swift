//
//  RequestConfiguration.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestConfiguration: URLRequestConvertible {
    
    var host: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var customHeaders: [String : String] { get }
    var parameters: [(Alamofire.ParameterEncoding, [String : CustomStringConvertible])] { get }
}

extension RequestConfiguration {
    
    func asURLRequest() throws -> URLRequest {

        guard let url = URL(string: host)?.appendingPathComponent(path)
            else {
                throw AFError.invalidURL(url: "/\(path)")
        }
        
        var urlRequest = URLRequest(url: url)

        //Parameter Encoding
        for (encoding, parametersForEncoding) in parameters {
            
            urlRequest = try encoding.encode(urlRequest, with: parametersForEncoding)
        }
        
        //HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        
        customHeaders.forEach { key, value in
            
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
