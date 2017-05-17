//
//  DarkSkyModelTest.swift
//  ForecasterSDK
//
//  Created by nsmachine on 5/18/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation

import XCTest

@testable import ForecasterSDK

class DarkSkyModelTest: XCTestCase {
    
    func testForecastModelObject() {
        
        guard let json = jsonFromFile("darksky", ofType: "json") else { XCTFail(); return }
        
        let currentlyJSON = json["currently"]
        let hourlyJSON = json["hourly"]["data"][0]
        let dailyJSON = json["daily"]["data"][0]
        
        let objectType: DarkSkyModel.Type = Forecast.self
        guard let currentForecast = objectType.init(json: currentlyJSON) as? Forecast else { XCTFail(); return }
        
        XCTAssertTrue(currentForecast.condition == .clear)
        XCTAssertTrue(currentForecast.temperature == 79.86)
        XCTAssertTrue(currentForecast.feelsLike == 79.86)
        XCTAssertTrue(currentForecast.windDirection == .SW)
        
        guard let hourlyForecast = objectType.init(json: hourlyJSON) as? Forecast else { XCTFail(); return }
        
        XCTAssertTrue(hourlyForecast.condition == .clear)
        XCTAssertTrue(hourlyForecast.temperature == 79.86)
        XCTAssertTrue(hourlyForecast.feelsLike == 79.86)
        XCTAssertTrue(hourlyForecast.windDirection == .SW)
        
        guard let dailyForecast = objectType.init(json: dailyJSON) as? Forecast else { XCTFail(); return }
        
        XCTAssertTrue(dailyForecast.condition == .partlyCloudy )
        XCTAssertTrue(dailyForecast.maxTemperature == 90.94)
        XCTAssertTrue(dailyForecast.minTemperature == 62.24)
        XCTAssertTrue(dailyForecast.windDirection == .SW)
        XCTAssertTrue(dailyForecast.sunriseTime > 0.0)
        XCTAssertTrue(dailyForecast.sunsetTime > 0.0)
    }
}
