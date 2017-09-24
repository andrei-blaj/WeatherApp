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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewInsideScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var HighLowStackView: UIStackView!
    
    // More Details View Outlets
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var moreDetailsTemperatureLbl: UILabel!
    @IBOutlet weak var moreDetailsSummaryLbl: UILabel!
    @IBOutlet weak var moreDetailsCurrentConditionImg: UIImageView!
    @IBOutlet weak var moreDetailsHourlySummary: UILabel!
    
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var rainProbabilityLbl: UILabel!
    
    // Variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var searchCancelBtnState: ButtonState!
    var moreDetailsCancelBtnState: MoreDetailsButtonState!
    var newLocation: Bool = false
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateLabels(_:)), name: NOTIF_MEASURING_UNIT_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateHideShowHiddenStatus(_:)), name: NOTIF_SHOW_HIDE_SWITCH_CHANGED, object: nil)
        
        // When the settings button is pressed
        settingsBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    @objc func updateLabels(_ notif: Notification) {
        self.fetchCoreDataObjects()
    }
    
    @objc func updateHideShowHiddenStatus(_ notif: Notification) {
        self.HighLowStackView.isHidden = !DataService.instance.userSettings[0].showHighLowLabel
    }
    
    // Initial settings for when the view loads
    func setupView() {
        
        DataService.instance.dataDidLoad = false
        moreDetailsBtn.isHidden = true
        
        searchCancelBtnState = .search
        moreDetailsCancelBtnState = .more
        
        DataService.instance.currentMeasuringUnit = ""
        viewInsideScrollView.frame.size.width = UIScreen.main.bounds.width
        
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchTextField.alpha = 0.0
        self.moreDetailsView.alpha = 0.0
        
        DataService.instance.currentMeasuringUnit = ""
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
///////////////////////////////////////////////////////////////////      Location Data     ///////////////////////////////////////////////////////////////////
    
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
                        DataService.instance.dataDidLoad = true
                        self.moreDetailsBtn.isHidden = false
                        self.newLocation = true
                        self.fetchCoreDataObjects()
                    } else {
                        print("> Failed to obtain a response from the API.")
                    }
                })
            }
        })
        
    }
    
///////////////////////////////////////////////////////////////////      Search Feature     ///////////////////////////////////////////////////////////////////
    
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
  
///////////////////////////////////////////////////////////////////      Updating On Screen Data     ///////////////////////////////////////////////////////////////////
    
    // Update the labels in the Main View Controller
    func updateLabels() {
        
        UIView.animate(withDuration: 0.5) {
            self.cityLbl.alpha = 0.0
            self.regionLabel.alpha = 0.0
            self.temperatureLbl.alpha = 0.0
            self.highTemp.alpha = 0.0
            self.lowTemp.alpha = 0.0
        }
        
        cityLbl.text = Location.instance.city
        regionLabel.text = "\(Location.instance.region), \(Location.instance.countryCode)"
        
        temperatureLbl.text = " \(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
        highTemp.text = "H:\(Int(round(DataService.instance.dailyForecast[0].temperatureHigh)))\(DEGREE_SIGN)"
        lowTemp.text = "L:\(Int(round(DataService.instance.dailyForecast[0].temperatureLow)))\(DEGREE_SIGN)"
        
        searchCancelBtnState = .search
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBtn.alpha = 0.0
        })
        
        searchBtn.setImage(UIImage(named: "search_btn"), for: .normal)
        
        // Animate the labels back in
        UIView.animate(withDuration: 0.5, animations: {
            self.cityLbl.alpha = 1.0
            self.regionLabel.alpha = 1.0
            if self.moreDetailsView.alpha == 0.0 {
                self.temperatureLbl.alpha = 1.0
                self.searchBtn.alpha = 1.0
            }
            self.highTemp.alpha = 1.0
            self.lowTemp.alpha = 0.75
            
            self.searchTextField.alpha = 0.0
        })
        
    }
    
    // Update the labels and elements in the MoreDetailsView
    func updateDetails() {
        
        self.moreDetailsTemperatureLbl.text = " \(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
        self.moreDetailsSummaryLbl.text = DataService.instance.currentConditions.summary
        self.moreDetailsHourlySummary.text = DataService.instance.hourlySummary
        
        self.moreDetailsCurrentConditionImg.image = UIImage(named: "\(DataService.instance.currentConditions.icon)")
        
        let sunrise = DataService.instance.dailyForecast[0].sunriseTime
        let sunset = DataService.instance.dailyForecast[0].sunsetTime
        
        self.sunriseLbl.text = "\(getHour(fromTimestamp: Int(sunrise))):\(getMinutes(fromTimestamp: Int(sunrise)))"
        self.sunsetLbl.text = "\(getHour(fromTimestamp: Int(sunset))):\(getMinutes(fromTimestamp: Int(sunset)))"
        
        self.humidityLbl.text = "\(Int(DataService.instance.currentConditions.humidity * 100))%"
        self.pressureLbl.text = "\(Int(round((DataService.instance.currentConditions.pressure / 1000) * 29.53))) inHg"
        
        self.windSpeedLbl.text = "\(Int(round(DataService.instance.currentConditions.windSpeed * 1.6))) kph"
        self.rainProbabilityLbl.text = "\(((Int(DataService.instance.currentConditions.precipProbability * 100) + 5) / 10) * 10)%"
        
        collectionView.reloadData()
        
    }
    
    func getHour(fromTimestamp timestamp: Int) -> String {
        let offset = DataService.instance.gmtOffset!
        let hour = ((timestamp + offset) / 3600) % 24
        
        if hour < 10 {
            return "0\(hour)"
        }
        
        return "\(hour)"
    }
    
    func getMinutes(fromTimestamp timestamp: Int) -> String {
        let offset = DataService.instance.gmtOffset!
        let minutes = ((timestamp + offset) / 60) % 60
        
        if minutes < 10 {
            return "0\(minutes)"
        }
        
        return "\(minutes)"
    }

///////////////////////////////////////////////////////////////////      Main View Button Actions     ///////////////////////////////////////////////////////////////////
    
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
                self.highTemp.alpha = 0.0
                self.lowTemp.alpha = 0.0

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
                self.highTemp.alpha = 1.0
                self.lowTemp.alpha = 0.75
                
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
    
///////////////////////////////////////////////////////////////////      Core Data     ///////////////////////////////////////////////////////////////////
    
    // Retrieve the data from the persistent container using a fetch request
    func fetch(completion: DownloadComplete) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<UserSettings>(entityName: "UserSettings")

        do {
            DataService.instance.userSettings = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }

    }

    // Initialize the information on the screen
    func fetchCoreDataObjects() {
        self.fetch { (success) in
            if success {
                let settings = DataService.instance.userSettings
                if settings.count < 1 {
                    self.save(completion: { (success) in
                        self.fetchCoreDataObjects()
                        return
                    })
 
                } else {
                
                    if (newLocation == true && settings[0].measuringUnit == "F") || (newLocation == false && DataService.instance.currentMeasuringUnit != "") {
                        DataService.instance.currentMeasuringUnit = settings[0].measuringUnit!
                        DataService.instance.convertTo(unit: settings[0].measuringUnit!)
                        newLocation = false
                    }
                    
                    self.HighLowStackView.isHidden = !DataService.instance.userSettings[0].showHighLowLabel
                    updateLabels()
                    updateDetails()
                }
            }
        }
    }
    
    // This save method only takes place the first time the app is installed to set the Celsius measuring unit by default
    func save(completion: DownloadComplete) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let userSetting = UserSettings(context: managedContext)
        
        userSetting.measuringUnit = "C"
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
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
        
            cell.configureCell(time: hour.time, image: hour.icon, temp: hour.temperature, index: indexPath.row, precip: hour.precipProbability)
        
            return cell
        }
        
        return HourlyConditionsCell()
    }
    
}
