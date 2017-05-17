//
//  LocationCell.swift
//  Forecaster
//
//  Created by nsmachine on 5/20/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet var locationName: UILabel?
    @IBOutlet var locationAreaAndCountry: UILabel?
    @IBOutlet var temperature: UILabel?
    @IBOutlet var temperatureUnit: UILabel?
    @IBOutlet var rainProbablity: UILabel?
    @IBOutlet var windSpeed: UILabel?
    @IBOutlet var windSpeedUnit: UILabel?
    @IBOutlet var currentConditions: UILabel?
}
