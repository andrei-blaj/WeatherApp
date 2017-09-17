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

    @IBOutlet weak var mainUnitBtn: UIButton!
    @IBOutlet weak var secondaryUnitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    @IBAction func onPoweredByDarkSkyPressed(_ sender: Any) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
        }
    }
    
    @IBAction func onSecondaryUnitBtnPressed(_ sender: Any) {
        
        if mainUnitBtn.currentTitle == "°C" {
            mainUnitBtn.setTitle("°F", for: .normal)
            secondaryUnitBtn.setTitle("°C", for: .normal)
        } else {
            mainUnitBtn.setTitle("°C", for: .normal)
            secondaryUnitBtn.setTitle("°F", for: .normal)
        }
        
//        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
//        let measuringUnit = MeasuringUnit(context: managedContext)
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<MeasuringUnit>(entityName: "MeasuringUnit")
        
        do {
            let value = try managedContext.fetch(fetchRequest)
            print(value)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        
        
    }
    
}
