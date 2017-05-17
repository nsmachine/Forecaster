//
//  DailyForecastCell.swift
//  Forecaster
//
//  Created by nsmachine on 5/21/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import UIKit

class DailyForecastCell: UITableViewCell {
    
    @IBOutlet var weekday: UILabel?
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet var maxTemperature: UILabel?
    @IBOutlet var minTemperature: UILabel?
}
