//
//  HourlyConditionsCell.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 16/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit

class HourlyConditionsCell: UICollectionViewCell {
    
    // Outlets
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var conditonImage: UIImageView!
    @IBOutlet weak var hourTemperatureLbl: UILabel!
    
    func configureCell(time: Double, image: String, temp: Double, index: Int) {
        let date = Date(timeIntervalSince1970: time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if index == 0 {
            hourLbl.text = "Now"
            conditonImage.image = UIImage(named: DataService.instance.currentConditions.icon)
            hourTemperatureLbl.text = "\(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
            
        } else {
            if hour < 10 { hourLbl.text = "0\(hour)" }
            else { hourLbl.text = "\(hour)" }
            
            conditonImage.image = UIImage(named: image)
            hourTemperatureLbl.text = "\(Int(round(temp)))\(DEGREE_SIGN)"
        }
    }
}
