//
//  ForecastProviderTest.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/18/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import ForecasterSDK

class ForecastProviderTest: XCTestCase {
    
    override func tearDown() {
        
        OHHTTPStubs.removeAllStubs()
        
        super.tearDown()
    }
    
    func testProviderType() {
        
        let provider = forecastProvider(.DarkSky)
        
        XCTAssertTrue(provider is DarkSkyAPIClient )
    }
    
    func testProviderAPI() {
        
        stub(condition: isHost("api.darksky.net") && pathStartsWith("/forecast")) { _ in
            let stubData = dataFromFile("darksky", ofType: "json")
            return OHHTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
        
        let expect = expectation(description: "")
        
        let location = Location()
        location.latitude  = 37.8267
        location.longitude = -122.4233
        
        let provider = forecastProvider(.DarkSky)
        
        provider.updateForecastFor(location: location) { (currently, hourly, daily, error) in
            
            XCTAssertTrue(currently != nil)
            XCTAssertTrue(hourly.count > 0)
            XCTAssertTrue(daily.count > 0)
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 30)
    }
}
