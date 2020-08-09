//
//  WeatherDetailViewController.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 07/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WeatherDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    
    
    var weatherService = WeatherService()
    var cityWeatherArray : [CityWeather] = []
    var cityCountry : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initInterface()
        self.weatherService.getExtendByCityCountry(cityCountry: self.cityCountry!, completion: self.doCompletionGetByCityCountry)
        self.initDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func doCompletionGetByCityCountry(data: [CityWeather]){
        self.cityWeatherArray.append(contentsOf: data)
        self.tableView.reloadData()
        //self.activityIndicator.stopAnimating()
    }
        
    func initDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func initInterface(){
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    // MARK: DELEGATES TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityWeather = self.cityWeatherArray[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? CustomTableViewCell
        cell!.setWeather(city: cityWeather)

        return cell!
    }
}
