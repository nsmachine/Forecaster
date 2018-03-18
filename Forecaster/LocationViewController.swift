//
//  LocationViewController.swift
//  Forecaster
//
//  Created by nsmachine on 5/16/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import UIKit

import ForecasterSDK

import RealmSwift

class LocationViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    var locations: Results<Location>?
    var locationForDetailsVC: Location?
    
    let viewModel = LocationViewModel()
    
    var token: NotificationToken?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let footerView = UIView()
        tableView?.tableFooterView = footerView
        
        locations = viewModel.loadLocations()
        token = locations?.observe({ [unowned self] (changes) in
            
            switch changes {
                
            case .initial(_):
                self.tableView?.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                self.tableView?.beginUpdates()
                self.tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .fade)
                self.tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .fade)
                self.tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .fade)
                self.tableView?.endUpdates()
                
            case .error(let error):
                print("\(error)")
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIApplication.shared.applicationState == .active {
            
            if let locs = locations, locs.count > 0 {
                viewModel.updateForecast()
            } else {
                
                performSegue(withIdentifier: "presentAddLocation", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "presentLocationDetails" {
            
            let vc = segue.destination as? LocationDetailsViewController
            vc?.location = locationForDetailsVC
        }
    }
    
    @objc func willEnterForeground(notification: Notification) {
        viewModel.updateForecast()
    }
    
    @IBAction
    func unwindToLocations(segue: UIStoryboardSegue) {
        
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        
        if let locations = locations {
            
            let location = locations[indexPath.row]
            
            cell.locationName?.text = location.locality
            cell.locationAreaAndCountry?.text = location.administrativeArea + ", " + location.isoCountryCode
            
            if let forecast = location.currently {
                
                cell.temperature?.text          = "\(Int(forecast.temperature))"
                cell.rainProbablity?.text       = "\(Int(forecast.rainProbablity * 100))"
                cell.windSpeed?.text            = "\(Int(forecast.windSpeed))"
                cell.currentConditions?.text    = forecast.summary
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        locationForDetailsVC = locations?[indexPath.row]
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "presentLocationDetails", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action = UITableViewRowAction(style: .default,
                                          title: "Delete",
                                          handler: { [weak self] (action, indexPath) in
                                            
                                            if let location = self?.locations?[indexPath.row] {
                                                self?.viewModel.deleteLocation(location: location)
                                            }
        })
        return [action]
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
