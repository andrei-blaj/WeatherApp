//
//  DailyCell.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 01/10/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var highTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    
    func configureCell(day: Int, image: String, highTemp: Double, lowTemp: Double) {
        
        let date = Date(timeIntervalSince1970: TimeInterval(day))
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        dayLabel.text = DAY_DICTIONARY[weekDay]
        iconImageView.image = UIImage(named: image)
        highTempLbl.text = "\(Int(round(highTemp)))\(DEGREE_SIGN)"
        lowTempLbl.text = "\(Int(round(lowTemp)))\(DEGREE_SIGN)"
        
    }

}
