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
    
    func configureCell(day: Int, iamge: String, highTemp: Double, lowTemp: Double) {
        
    }

}
