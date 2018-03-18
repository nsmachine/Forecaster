//
//  Request.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import Alamofire

public enum RequestStatus: String, CustomStringConvertible {
    
    case notStarted         = "Not Started"
    case running            = "Running"
    case cancelled          = "Cancelled"
    case completed          = "Completed"
    
    public var description: String { return self.rawValue }
}

class Request {
    
    typealias RequestCompletion = (_ data: Data?, _ error: Error?) -> Void
    
    private(set) var id: UUID = UUID()
    
    let config: RequestConfiguration
    
    private(set) var status: RequestStatus = .notStarted
    private(set) var request: Alamofire.DataRequest?
    
    private var completion: RequestCompletion?
    
    init(config: RequestConfiguration) {
        
        self.config = config
    }
    
    deinit {
        
    }
    
    func completion(_ completion: @escaping RequestCompletion) {
        
        self.completion = completion
    }
    
    func start() {
        
        switch status {
        case .notStarted:
            break
        default:
            return
        }
        
        status = .running
        
        Request.requests[id] = self
        
        request = Request.sessionManager.request(config)
        request?.responseData(queue: ForecasterSDK.responseQueue, completionHandler: { [weak self] (response) in
            
            guard let strongSelf = self else { return }
            
            guard strongSelf.status != .cancelled else { return }
            
            strongSelf.status = .completed
            
            strongSelf.completion?(response.result.value, response.result.error)
            
            Request.requests[strongSelf.id] = nil
        })
        
        request?.resume()
    }
    
    func cancel() {
        
        switch status {
        case .running:
            break
        default:
            return
        }
        
        status = .cancelled
        request?.cancel()
        completion = nil
        
        Request.requests[id] = nil
    }
}

extension Request {
    
    static var requests: [UUID : Request] = [:]
    
    fileprivate static var sessionManager: Alamofire.SessionManager {
        
        return foregroundSessionManager
    }
    
    fileprivate static var backgroundSessionManager: Alamofire.SessionManager = {() -> Alamofire.SessionManager in
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.forecaster.backgroundURLSession")
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }()
    
    fileprivate static var foregroundSessionManager: Alamofire.SessionManager = {() -> Alamofire.SessionManager in
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 30
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }()
}
