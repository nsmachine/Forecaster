//
//  LocationDetailViewController.swift
//  Forecaster
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import UIKit

import ForecasterSDK

class LocationDetailsViewController: UIViewController {
    
    @IBOutlet var hourlyForecastView: UICollectionView?
    @IBOutlet var dailyForecastView: UITableView?
    
    @IBOutlet var locationName: UILabel?
    @IBOutlet var temperature: UILabel?
    @IBOutlet var maxTemperature: UILabel?
    @IBOutlet var minTemperature: UILabel?
    @IBOutlet var todaysDay: UILabel?
    
    var timeFormatter: DateFormatter?
    var hourFormatter12: DateFormatter?
    var hourFormatter24: DateFormatter?
    var weekdayFormatter: DateFormatter?
    
    var location: Location?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let footer = UIView()
        dailyForecastView?.tableFooterView = footer
        temperature?.adjustsFontSizeToFitWidth = true
        
        timeFormatter = DateFormatter()
        timeFormatter?.timeZone = TimeZone(identifier: location?.timeZone ?? "UTC")
        timeFormatter?.dateFormat = "h:mm a"
        
        hourFormatter12 = DateFormatter()
        hourFormatter12?.timeZone = TimeZone(identifier: location?.timeZone ?? "UTC")
        hourFormatter12?.dateFormat = "h a"
        
        hourFormatter24 = DateFormatter()
        hourFormatter24?.timeZone = TimeZone(identifier: location?.timeZone ?? "UTC")
        hourFormatter24?.dateFormat = "HH"
        
        weekdayFormatter = DateFormatter()
        weekdayFormatter?.timeZone = TimeZone(identifier: location?.timeZone ?? "UTC")
        weekdayFormatter?.dateFormat = "EEEE"
        
        hourlyForecastView?.allowsSelection = false
        
        locationName?.text = location?.locality
        if let forecast = location?.currently {
            temperature?.text = "\(Int(forecast.temperature))"
        }
        
        if let forecast = location?.daily.first {
            
            let date = Date(timeIntervalSince1970: forecast.time)
            todaysDay?.text = weekdayFormatter?.string(from: date)
            
            maxTemperature?.text = "\(Int(forecast.maxTemperature))"
            minTemperature?.text = "\(Int(forecast.minTemperature))"
        }
    }
    
    func dismiss() {
        
        performSegue(withIdentifier: "unwindToLocationFromDetails", sender: self)
    }
    
    @IBAction
    func backToLocations(_ sender: AnyObject) {
        dismiss()
    }
}

extension LocationDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return location?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyForecastCell", for: indexPath) as! HourlyForecastCell
        
        if let forecast = location?.hourly[indexPath.item] {
            
            let date = Date(timeIntervalSince1970: forecast.time)
            cell.hour?.text = hourFormatter12?.string(from: date)
            cell.temperature?.text = "\(Int(forecast.temperature))"
            
            var sunsetHour = 18
            
            if let todaysForecast = location?.daily.first {
                let sunsetDate = Date(timeIntervalSince1970: todaysForecast.sunsetTime)
                sunsetHour = Int(hourFormatter24?.string(from: sunsetDate) ?? "-1") ?? 18
            }
            
            var sunriseHour = 6
            
            if let todaysForecast = location?.daily.first {
                let sunriseDate = Date(timeIntervalSince1970: todaysForecast.sunriseTime)
                sunriseHour = Int(hourFormatter24?.string(from: sunriseDate) ?? "-1") ?? 6
            }
            
            var iconStyle: WeatherCondition.IconStyle = .None
            
            if let hour = Int(hourFormatter24?.string(from: date) ?? "-1") {
                
                if hour > sunriseHour && hour <= sunsetHour {
                    iconStyle = .Day
                } else if (hour > sunsetHour && hour <= 23) || (hour >= 0 && hour <= sunriseHour) {
                    iconStyle = .Night
                }
            }

            cell.weatherIcon?.image = forecast.condition.icon(style: iconStyle)
        }
        
        return cell
    }
}

extension LocationDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if let count = location?.daily.count {
                return count - 1
            } else {
                return 0
            }
        case 1:
            return 1
        case 2:
            return 8
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        default:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecastCell", for: indexPath) as! DailyForecastCell
            
            if let forecast = location?.daily[indexPath.row + 1] {
                
                let date = Date(timeIntervalSince1970: forecast.time)
                cell.weekday?.text = weekdayFormatter?.string(from: date)
                
                cell.maxTemperature?.text = "\(Int(forecast.maxTemperature))"
                cell.minTemperature?.text = "\(Int(forecast.minTemperature))"
                
                cell.weatherIcon?.image = forecast.condition.icon(style: .None)
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todaySummaryCell", for: indexPath) as! TodaySummaryCell
            
            if let forecast = location?.daily.first {
                
                cell.summary?.text = forecast.summary
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayDetailsCell", for: indexPath) as! TodayDetailsCell
            
            if let forecastToday = location?.daily.first, let forecastCurrently = location?.currently {
                
                var detailTitle: String?
                var detailValue: String?
                
                switch indexPath.row {
                case 0:
                    detailTitle = "Sunrise"
                    let date = Date(timeIntervalSince1970: forecastToday.sunriseTime)
                    detailValue = timeFormatter?.string(from: date)
                case 1:
                    detailTitle = "Sunset"
                    let date = Date(timeIntervalSince1970: forecastToday.sunsetTime)
                    detailValue = timeFormatter?.string(from: date)
                case 2:
                    detailTitle = "Chance of Rain"
                    detailValue = "\(Int(forecastCurrently.rainProbablity * 100))%"
                case 3:
                    detailTitle = "Humidity"
                    detailValue = "\(Int(forecastCurrently.humidity * 100))%"
                case 4:
                    detailTitle = "Wind"
                    detailValue = "\(forecastCurrently.windDirection) \(Int(forecastCurrently.windSpeed)) mph"
                case 5:
                    detailTitle = "Feels Like"
                    detailValue = "\(Int(forecastCurrently.feelsLike))"
                case 6:
                    detailTitle = "Pressure"
                    detailValue = "\(Int(forecastCurrently.pressure))"
                case 7:
                    detailTitle = "Visibility"
                    detailValue = "\(Int(forecastCurrently.visibility)) mi"
                default:
                    break
                }
                
                cell.detailTitle?.text = detailTitle
                cell.detailValue?.text = detailValue
            }
            
            return cell
        }
    }
}

