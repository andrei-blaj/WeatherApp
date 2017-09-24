//
//  SettingsVC.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 13/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit
import CoreData

class SettingsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var mainUnitBtn: UIButton!
    @IBOutlet weak var secondaryUnitBtn: UIButton!
    @IBOutlet weak var showHideSwitcher: UISwitch!
    
    // Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCoreDataObjects()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onPoweredByDarkSkyPressed(_ sender: Any) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
        }
    }
    
///////////////////////////////////////////////////////////////////      Settings Actions     ///////////////////////////////////////////////////////////////////
    
    // This function is called whenever the state of the switch is changed
    @IBAction func didChangeState(_ sender: Any) {
    
        if showHideSwitcher.isOn {
            saveSwitchOption(option: false)
            showHideSwitcher.setOn(false, animated: true)
        } else {
            saveSwitchOption(option: true)
            showHideSwitcher.setOn(true, animated: true)
        }
        
        NotificationCenter.default.post(name: NOTIF_SHOW_HIDE_SWITCH_CHANGED, object: nil)
    }

    // This function is called whenever the user taps on the right hand button from the settings stack view
    // It changes the elementes in the current view and also sends out a notification to change elements in the Main view controller
    @IBAction func onSecondaryUnitBtnPressed(_ sender: Any) {
        
        if !DataService.instance.dataDidLoad {
            return
        }
        
        var newMeasuringUnit = ""
        
        if mainUnitBtn.currentTitle == "°C" {
            mainUnitBtn.setTitle("°F", for: .normal)
            secondaryUnitBtn.setTitle("°C", for: .normal)
            newMeasuringUnit = "F"
        } else {
            mainUnitBtn.setTitle("°C", for: .normal)
            secondaryUnitBtn.setTitle("°F", for: .normal)
            newMeasuringUnit = "C"
        }
        
        DataService.instance.currentMeasuringUnit = newMeasuringUnit
        saveMeasuringUnit(newMeasuringUnit: newMeasuringUnit)
        NotificationCenter.default.post(name: NOTIF_MEASURING_UNIT_CHANGED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
    
///////////////////////////////////////////////////////////////////      Core Data     ///////////////////////////////////////////////////////////////////
    
    // Saves to the persistent container the chosen measuring unit, picked by the user
    func saveMeasuringUnit(newMeasuringUnit: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
    
        do {
            DataService.instance.userSettings[0].measuringUnit = newMeasuringUnit
            try managedContext.save()
        } catch {
            debugPrint("Could not update measuring unit: \(error.localizedDescription)")
        }
        
    }
    
    // Saves to the persistent container the chosen switch state
    func saveSwitchOption(option: Bool) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        do {
            DataService.instance.userSettings[0].showHighLowLabel = option
            try managedContext.save()
        } catch {
            debugPrint("Could not switch: \(error.localizedDescription)")
        }
    }
    
    // Initialize the elements on the screen: button titles, switch state
    func fetchCoreDataObjects() {
        self.fetch { (success) in
            if success {
                let settings = DataService.instance.userSettings
                
                // We assume that the application loaded properly and that the
                // Core Data contains the initial settings
                    
                mainUnitBtn.setTitle("°\(settings[0].measuringUnit!)", for: .normal)
                showHideSwitcher.setOn(settings[0].showHighLowLabel, animated: true)
                
                if settings[0].measuringUnit! == "C" {
                    secondaryUnitBtn.setTitle("°F", for: .normal)
                } else {
                    secondaryUnitBtn.setTitle("°C", for: .normal)
                }
                
            }
        }
    }
    
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
    
}
