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
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var moreDetailsBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // More Details View Outlets
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var moreDetailsTemperatureLbl: UILabel!
    @IBOutlet weak var moreDetailsSummaryLbl: UILabel!
    @IBOutlet weak var moreDetailsCurrentConditionImg: UIImageView!
    @IBOutlet weak var moreDetailsHourlySummary: UILabel!
    
    // Variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var searchCancelBtnState: ButtonState!
    var moreDetailsCancelBtnState: MoreDetailsButtonState!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchCancelBtnState = .search
        moreDetailsCancelBtnState = .more
        
        settingsBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchTextField.alpha = 0.0
        self.moreDetailsView.alpha = 0.0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // Location Manager
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchByUserInput()
        return true
    }
    
    // Search for a city and find its coordinates
    func searchByUserInput() {
        // 1. Hide the keyboard
        self.view.endEditing(true)
        // 2. Get the inserted text from the textField as a City Name
        let cityName = searchTextField.text!
        // 3. Search for the City Name using the MapKit and get the coordinates
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = cityName
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        // Search for the city name
        activeSearch.start { (response, error) in
            if response == nil {
                debugPrint(error?.localizedDescription as String!)
            } else {
                
                let newLatitude = response?.boundingRegion.center.latitude
                let newLongitude = response?.boundingRegion.center.longitude
                // Update the MainVC labels with the new information & Hide the search bar
                self.loadLocationData(forLatitude: newLatitude!, andLongitude: newLongitude!)
            }
        }
        
    }
    
    // Load the data for the passed coordinates
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
    
    // Update the labels in the Main View Controller
    func updateLabels() {
        
        UIView.animate(withDuration: 0.5) {
            self.cityLbl.alpha = 0.0
            self.regionLabel.alpha = 0.0
            self.temperatureLbl.alpha = 0.0
        }
        
        cityLbl.text = Location.instance.city
        regionLabel.text = "\(Location.instance.region), \(Location.instance.countryCode)"
        
        temperatureLbl.text = " \(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
        
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
            
            self.searchTextField.alpha = 0.0
            self.searchBtn.alpha = 1.0
        })
        
    }
    
    // The moment the "Search" btn is pressed
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

                self.searchTextField.alpha = 1.0
                self.searchBtn.alpha = 1.0
            })

        } else {
            self.view.endEditing(true)
            
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
                
                self.searchTextField.alpha = 0.0
                self.searchBtn.alpha = 1.0
            })
        }
        
    }
    
    // The moment the "Location" Btn is pressed
    @IBAction func onLocationBtnPressed(_ sender: Any) {
        loadLocationData(forLatitude: currentLocation.coordinate.latitude, andLongitude: currentLocation.coordinate.longitude)
    }
    
    // The moment the "More Details" Btn is pressed
    @IBAction func onMoreDetailsBtnPressed(_ sender: Any) {
        
        if moreDetailsCancelBtnState == .more {
            
            updateDetails()
            
            self.moreDetailsCancelBtnState = .cancel

            UIView.animate(withDuration: 0.3, animations: {
                self.moreDetailsBtn.alpha = 0.0
                self.locationBtn.alpha = 0.0
                self.searchBtn.alpha = 0.0
            })

            self.moreDetailsBtn.setBackgroundImage(nil, for: .normal)
            self.moreDetailsBtn.setImage(UIImage(named: "cancel_btn"), for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.temperatureLbl.alpha = 0.0
                self.moreDetailsBtn.alpha = 1.0
                self.moreDetailsView.alpha = 1.0
            }
            
        } else {
            
            self.moreDetailsCancelBtnState = .more

            UIView.animate(withDuration: 0.3, animations: {
                self.moreDetailsBtn.alpha = 0.0
            })

            self.moreDetailsBtn.setImage(nil, for: .normal)
            self.moreDetailsBtn.setBackgroundImage(UIImage(named: "menu"), for: .normal)

            UIView.animate(withDuration: 0.3) {
                self.temperatureLbl.alpha = 1.0
                self.moreDetailsBtn.alpha = 1.0
                self.locationBtn.alpha = 1.0
                self.searchBtn.alpha = 1.0
                self.moreDetailsView.alpha = 0.0
            }
        }
 
    }
    
    // Update the labels and elements in the MoreDetailsView
    func updateDetails() {
        
        self.moreDetailsTemperatureLbl.text = " \(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
        self.moreDetailsSummaryLbl.text = DataService.instance.currentConditions.summary
        self.moreDetailsHourlySummary.text = DataService.instance.hourlySummary
        
        self.moreDetailsCurrentConditionImg.image = UIImage(named: "\(DataService.instance.currentConditions.icon)")
        
        collectionView.reloadData()
        
    }
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyConditionsCell", for: indexPath) as? HourlyConditionsCell {
            let hour = DataService.instance.hourlyForecast[indexPath.row]
        
            cell.configureCell(time: hour.time, image: hour.icon, temp: hour.temperature, index: indexPath.row)
        
            return cell
        }
        
        return HourlyConditionsCell()
    }
    
}























