//
//  WeatherPrincipalViewController.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 07/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreLocation

extension WeatherPrincipalViewController: WeatherPrincipalDelegate{
    func cityCountry(text: String){
        self.cityCountry = text
    }
}

class WeatherPrincipalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var buttonSelectCity: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Services
    var citiesService = CityService()
    var weatherService = WeatherService()
    var locationManager = LocationManager()
    
    var cityCountry : String?
    var cityCountrySelected : String?
    var cityWeatherArray : [CityWeather] = []
    
    // MARK: VIEWMETHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDelegates()
        self.initInterface()
        self.initCurrentWeather()
        self.initDataFromRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.startAnimating()
        if (self.cityCountry != nil) {
            weatherService.getByCityCountry(cityCountry: self.cityCountry!, completion: self.doCompletionGetByCityCountry, error: self.doErrorGetByCityCountry)
        }
    }
    
    // MARK: INITMETHODS
    
    private func initDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.locationManager.locManager.delegate = self
    }
    
    private func initInterface(){
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.buttonSelectCity.layer.cornerRadius = 15
    }
    
    private func initCurrentWeather(){
        let coordinates = self.locationManager.getLocation()
        self.weatherService.getByLatLon(lat: coordinates.0, lon: coordinates.1, completion: self.doCompletionGetByCityCountryRealm)
    }
    
    private func initDataFromRealm(){
        let stored = CityWeatherDBManager.sharedInstance.getDataFromDB()
        for s in stored{
            weatherService.getByCityCountry(cityCountry: s.cityCountry, completion: self.doCompletionGetByCityCountryRealm, error: self.doErrorGetByCityCountry)
        }
    }
    //To save the first start of the application when the permissions are not given yet
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            self.initCurrentWeather()
        default:
            print("Not Location")
        }
    }
    
    // MARK: CALLBACKS
    
    private func doCompletionGetByCityCountryRealm(data: CityWeather){
        self.cityWeatherArray.append(data)
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    private func doCompletionGetByCityCountry(data: CityWeather){
        self.cityWeatherArray.append(data)
        CityWeatherDBManager.sharedInstance.new(cityCountry: data.cityCountry)
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    private func doErrorGetByCityCountry(data: String){
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Ciudad no encontrada", message: "No existe información del pronóstico de la ciudad \(data)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: ACTIONBUTTONS
    
    @IBAction func buttonSelectCityClicked(_ sender: Any) {
        if(cityWeatherArray.count < 5){
            self.performSegue(withIdentifier: "pickerCitySegue", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "Cantidad Máxima de Ciudades", message: "La cantidad máxima de ciudades es 5", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonUpdateClicked(_ sender: Any) {
        let buttonUpdate = (sender as? UIBarButtonItem)
        self.restrictClickButtonUpdate(sender: buttonUpdate!)
        self.cityWeatherArray = []
        self.activityIndicator.startAnimating()
        self.initCurrentWeather()
        self.initDataFromRealm()
    }
    
    private func restrictClickButtonUpdate(sender: UIBarButtonItem){
        sender.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
            sender.isEnabled = true
        })
    }
    
    
    // MARK: DELEGATES TABLEVIEW
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityWeatherArray.count
     }
     
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityWeather = self.cityWeatherArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? CustomTableViewCell
        cell!.setWeather(city: cityWeather)
        
        return cell!
     }
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") { (action, sourceView, completionHandler) in
            CityWeatherDBManager.sharedInstance.deleteFromDbByCityCountry(cityCountry: self.cityWeatherArray[indexPath.row].cityCountry)
            self.cityWeatherArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityCountrySelected = self.cityWeatherArray[indexPath.row].cityCountry
        self.performSegue(withIdentifier: "detailWeatherSegue", sender: nil)
    }
    
    // MARK: SEGUEMETHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is WeatherPickerViewController
        {
            let vc = segue.destination as? WeatherPickerViewController
            vc?.weatherPrincipalDelegate = self
            vc?.cityWeatherArray = self.cityWeatherArray
        }
        else if segue.destination is WeatherDetailViewController
        {
            let vc = segue.destination as? WeatherDetailViewController
            vc?.cityCountry = self.cityCountrySelected
        }
    }
    
}
