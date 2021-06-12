//
//  ViewController.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var businessTableView: UITableView!
    
    var businesses: [Business] = [Business]()
    
    var locationManager = CLLocationManager()
    var currLongitude: CLLocationDegrees!
    var currLatitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        businesses.append(Business(name: "Bob's Burgers"))
        businesses.append(Business(name: "Fatheads"))
        businesses.append(Business(name: "Houghs"))
        
        self.businessTableView.dataSource = self
        self.businessTableView.delegate = self
        self.registerTableViewCells()
    }

    @IBAction func searchYelp(_ sender: Any) {
        getLocation()
    }
    
    private func getLocation() {
        let status = CLLocationManager.authorizationStatus()

        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            presentLocationUIAlert()
            return
        }
        
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.requestLocation()
        
    }
    
    func presentLocationUIAlert() {
        let alert = UIAlertController(title: "This feature requires Location Services", message: "Turn on Location Services to search businesses near you", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in

            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    // MARK: UITableViewDelegate
    private func registerTableViewCells() {
        let businessCell = UINib(nibName: "BusinessTableViewCell",
                                  bundle: nil)
        self.businessTableView.register(businessCell,
                                forCellReuseIdentifier: "BusinessTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as? BusinessTableViewCell {
            cell.setCell(business: businesses[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: CLLocationManagerDelegate
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
            YelpQueries.searchBusinesses(searchTerm: searchTextField.text!, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        }
    }
    
   
}

