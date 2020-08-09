//
//  WeatherPickerViewController.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 07/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol WeatherPrincipalDelegate {
    func cityCountry(text: String)
}

class WeatherPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerCountry: UIPickerView!
    @IBOutlet weak var pickerCity: UIPickerView!
    @IBOutlet weak var buttonAgregarCiudad: UIButton!
    
    var weatherPrincipalDelegate : WeatherPrincipalDelegate?
    var citiesServices = CityService()
    
    //Vars UIPickers
    var countriesArray : [String] = []
    var citiesArray : [String] = []
    var countrySelected : Int = 0
    var citySelected : Int = 0
    
    //Var validations
    var cityWeatherArray : [CityWeather] = []
    
    // MARK: VIEWMETHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countriesArray = self.citiesServices.getCountries()!
        self.citiesArray = self.citiesServices.getCitiesByCountry(country: self.countriesArray[0])!
        self.initDelegates()
        self.initInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initDelegates(){
        self.pickerCountry.delegate = self
        self.pickerCountry.dataSource = self
        self.pickerCity.delegate = self
        self.pickerCity.dataSource = self
    }
    
    private func initInterface(){
        self.buttonAgregarCiudad.layer.cornerRadius = 15
    }
    
    private func validateCountryChoosen(){
        let cityCountry = citiesArray[citySelected] + ", " + countriesArray[countrySelected]
        for i in self.cityWeatherArray{
            if(i.cityCountry == cityCountry){
                let alert = UIAlertController(title: "Ciudad ya agregada", message: "La ciudad ya fue agregada", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        self.weatherPrincipalDelegate?.cityCountry(text: cityCountry)
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: BUTTONS CLICKEDS
    
    @IBAction func addClicked(_ sender: Any) {
        self.validateCountryChoosen()
    }
    
    @IBAction func agregarCiudadClicked(_ sender: Any) {
        self.validateCountryChoosen()
    }
    
    // MARK: PICKERVIEW DELEGATES
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerCountry {
            return self.countriesArray.count
        } else if pickerView == self.pickerCity{
            return self.citiesArray.count
        }
        return 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerCountry {
            return self.countriesArray[row]
        } else if pickerView == self.pickerCity{
            return self.citiesArray[row]
        }
        return nil
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerCountry {
            self.countrySelected = row
            self.citiesArray = self.citiesServices.getCitiesByCountry(country: self.countriesArray[row])!
            self.pickerCity.reloadAllComponents()
        } else if pickerView == self.pickerCity{
            self.citySelected = row
        }

    }
}
