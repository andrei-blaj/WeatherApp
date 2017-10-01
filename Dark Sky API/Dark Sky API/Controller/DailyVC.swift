//
//  DailyVC.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 30/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit

class DailyVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countyRegionLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cityNameLabel.text = Location.instance.city
        countyRegionLabel.text = "\(Location.instance.region), \(Location.instance.countryCode)"
        summaryLabel.text = DataService.instance.dailySummary
        
    }
    
    @IBAction func onBackBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
}

extension DailyVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as? DailyCell {
            
            
            
            return cell
        }
        
        return DailyCell()
    }
    
}
