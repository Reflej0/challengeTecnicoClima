//
//  CityWeather.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 08/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation

class CityWeather{
    var cityCountry: String
    var cityId : String
    var weatherIcon : String
    var max : String
    var min : String
    var now : String
    var dateTime: String?
    
    init(cityCountry: String, cityId: String, weatherIcon: String, max: String, min: String, now: String) {
        self.cityCountry = cityCountry
        self.cityId = cityId
        self.weatherIcon = weatherIcon
        self.max = String(max.prefix(5))
        self.min = String(min.prefix(5))
        self.now = String(now.prefix(5))
    }
    
    func setdateTime(dateTime: String){
        let firstSplit = dateTime.components(separatedBy: " ")
        let secondSplit = firstSplit[0].components(separatedBy: "-")
        let final = secondSplit[2] + "-" + secondSplit[1] + "-" + secondSplit[0] + " " + firstSplit [1]
        self.dateTime = final
    }
}
