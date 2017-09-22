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
    @IBOutlet weak var precipitationProbability: UILabel!
    
    func configureCell(time: Int, image: String, temp: Double, index: Int, precip: Double) {
        let hour = Int((time / 3600) % 24)
        
        if index == 0 {
            hourLbl.text = "Now"
            conditonImage.image = UIImage(named: DataService.instance.currentConditions.icon)
            hourTemperatureLbl.text = "\(Int(round(DataService.instance.currentConditions.temperature)))\(DEGREE_SIGN)"
            if DataService.instance.currentConditions.precipProbability * 100 > 14 {
                precipitationProbability.text = "\((Int(DataService.instance.currentConditions.precipProbability * 100) + 5) / 10) * 10)%"
            } else {
                precipitationProbability.text = ""
            }
            
            
        } else {
            if hour < 10 { hourLbl.text = "0\(hour)" }
            else { hourLbl.text = "\(hour)" }
            
            conditonImage.image = UIImage(named: image)
            hourTemperatureLbl.text = "\(Int(round(temp)))\(DEGREE_SIGN)"
            if Int(precip * 100) > 14 {
                precipitationProbability.text = "\(((Int(precip * 100) + 5) / 10) * 10)%"
            } else {
                precipitationProbability.text = ""
            }
        }
    }
}
