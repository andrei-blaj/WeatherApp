//
//  MainVC.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 11/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var summaryLbl: UILabel!
    
    // Variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var searchCancelBtnState: ButtonState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        searchCancelBtnState = .search
        
        settingsBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchTextField.alpha = 0.0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = self.locationManager.location
            
            // Passing the current location coordinates to the 'Location' singleton class
            let x = currentLocation.coordinate.latitude
            let y = currentLocation.coordinate.longitude
            
            loadLocationData(forLatitude: x, andLongitude: y)
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLabels() {
        
        UIView.animate(withDuration: 0.5) {
            self.cityLbl.alpha = 0.0
            self.regionLabel.alpha = 0.0
            self.temperatureLbl.alpha = 0.0
            self.summaryLbl.alpha = 0.0
        }
        
        cityLbl.text = Location.instance.city
        regionLabel.text = "\(Location.instance.region), \(Location.instance.countryCode)"
        
        temperatureLbl.text = " \(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
        summaryLbl.text = "\(DataService.instance.currentConditions.summary.capitalized)"
        
        searchCancelBtnState = .search
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBtn.alpha = 0.0
        })
        
        searchBtn.setImage(UIImage(named: "search_btn"), for: .normal)
        
        // Animate the labels back in
        UIView.animate(withDuration: 0.5, animations: {
            self.cityLbl.alpha = 1.0
            self.regionLabel.alpha = 1.0
            self.temperatureLbl.alpha = 1.0
            self.summaryLbl.alpha = 1.0
            
            self.searchTextField.alpha = 0.0
            self.searchBtn.alpha = 1.0
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // When the search button is pressed, I should:
        // 1. Hide the keyboard
        // 2. Get the inserted text from the textField as a City Name
        // 3. Search for the City Name using the MapKit and get the coordinates
        // 4. Update the MainVC labels with the new information
        // 5. Hide the search bar
        
        searchByUserInput()
        
        return true
    }
    
    func searchByUserInput() {
        // 1.
        self.view.endEditing(true)
        // 2.
        let cityName = searchTextField.text!
        print(cityName)
        // 3
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = cityName
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if response == nil {
                debugPrint(error?.localizedDescription)
            } else {
                
                let newLatitude = response?.boundingRegion.center.latitude
                let newLongitude = response?.boundingRegion.center.longitude
                // 4 & 5
                self.loadLocationData(forLatitude: newLatitude!, andLongitude: newLongitude!)
            }
        }
        
    }
    
    func loadLocationData(forLatitude x: CLLocationDegrees, andLongitude y: CLLocationDegrees) {
        
        Location.instance.latitude = x
        Location.instance.longitude = y
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: x, longitude: y)
        
        // Getting the correct information about the user's location
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                // Place details
                var placemark: CLPlacemark?
                placemark = placemarks?[0]
                
                DataService.instance.getLocationData(placemark: placemark!)
                    DataService.instance.downloadDarkSkyData(completed: { (success) in
                        if success {
                            print("> Success")
                            self.updateLabels()
                        } else {
                            print("> Failed to obtain a response from the API.")
                        }
                    })
            }
        })
        
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        
        if searchCancelBtnState == .search {
            
            searchTextField.text = ""
            searchCancelBtnState = .cancel

            UIView.animate(withDuration: 0.3, animations: {
                self.searchBtn.alpha = 0.0
            })

            searchBtn.setImage(UIImage(named: "cancel_btn"), for: .normal)

            // Animate the labels out and the search field in
            UIView.animate(withDuration: 0.3, animations: {
                self.cityLbl.alpha = 0.0
                self.regionLabel.alpha = 0.0
                self.temperatureLbl.alpha = 0.0
                self.summaryLbl.alpha = 0.0

                self.searchTextField.alpha = 1.0
                self.searchBtn.alpha = 1.0
            })

        } else {
            self.view.endEditing(true)
            
            animateSearchBtn()
        }
    }
    
    func animateSearchBtn() {
        searchCancelBtnState = .search
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBtn.alpha = 0.0
        })
        
        searchBtn.setImage(UIImage(named: "search_btn"), for: .normal)
        
        // Animate the labels back in
        UIView.animate(withDuration: 0.3, animations: {
            self.cityLbl.alpha = 1.0
            self.regionLabel.alpha = 1.0
            self.temperatureLbl.alpha = 1.0
            self.summaryLbl.alpha = 1.0
            
            self.searchTextField.alpha = 0.0
            self.searchBtn.alpha = 1.0
        })
    }
    
    @IBAction func onLocationBtnPressed(_ sender: Any) {
        loadLocationData(forLatitude: currentLocation.coordinate.latitude, andLongitude: currentLocation.coordinate.longitude)
    }
}

