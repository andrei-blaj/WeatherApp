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
    
    @IBAction func onSecondaryUnitBtnPressed(_ sender: Any) {
        
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
    
    // Core Data
    func saveMeasuringUnit(newMeasuringUnit: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
    
        do {
            DataService.instance.userSettings[0].measuringUnit = newMeasuringUnit
            try managedContext.save()
            print("Successfully updated measuring unit!")
        } catch {
            debugPrint("Could not update measuring unit: \(error.localizedDescription)")
        }
        
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (success) in
            if success {
                let settings = DataService.instance.userSettings
                
                // We assume that the application loaded properly and that the
                // Core Data contains the initial settings
                    
                mainUnitBtn.setTitle("°\(settings[0].measuringUnit!)", for: .normal)
                
                if settings[0].measuringUnit! == "C" {
                    secondaryUnitBtn.setTitle("°F", for: .normal)
                } else {
                    secondaryUnitBtn.setTitle("°C", for: .normal)
                }
                
            }
        }
    }
    
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
