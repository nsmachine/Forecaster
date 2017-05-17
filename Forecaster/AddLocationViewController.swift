//
//  AddLocationViewController.swift
//  Forecaster
//
//  Created by nsmachine on 5/20/17.
//  Copyright © 2017 nsmachine. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift

class AddLocationViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet var searchBar: UISearchBar?
    
    let viewModel = AddLocationViewModel()
    let disposeBag = DisposeBag()
    
    var results: [MKLocalSearchCompletion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.black
        
        let footer = UIView()
        tableView?.tableFooterView = footer
        
        searchBar?.keyboardAppearance = .dark
        
        viewModel.searchPublisher.subscribe(onNext: { [unowned self] (publishedValue) in
            
            self.results = publishedValue
            self.tableView?.reloadData()
            
        }).addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar?.becomeFirstResponder()
    }
    
    func dismiss() {
        
        searchBar?.resignFirstResponder()
        performSegue(withIdentifier: "unwindToLocationFromAddLocation", sender: self)
    }
}

extension AddLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addLocationCell", for: indexPath) as! AddLocationCell
        
        let location = results[indexPath.row]
        cell.locationName?.text = "\(location.title), \(location.subtitle)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = results[indexPath.row]
        let address = "\(location.title), \(location.subtitle)"
        viewModel.addToUserLocations(address: address) { [weak self] in
            
            self?.dismiss()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchForLocationUsing(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        dismiss()
    }
}
