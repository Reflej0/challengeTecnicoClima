//
//  Weather.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 07/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService{
    let ENDPOINT = "https://api.openweathermap.org/data/2.5/"
    let API_KEY = "ea3dd3f72755d09e509dff542c200869"
    
    public func getByCityCountry(cityCountry: String, completion: @escaping (CityWeather) -> Void, error: @escaping (String) -> Void){
        let url = "\(ENDPOINT)weather?q=\(cityCountry)&appid=\(API_KEY)&units=metric&lang=es"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedURL!, method: .get).responseJSON {
          response in
            guard let data = response.value else {return }
            if response.response!.statusCode == 200 {
                let jsonData = JSON(data)
                
                let cityCountry = cityCountry
                let cityId = jsonData["id"].stringValue
                let weatherIcon = jsonData["weather"][0]["icon"].stringValue
                let max = jsonData["main"]["temp_max"].stringValue
                let min = jsonData["main"]["temp_min"].stringValue
                let now = jsonData["main"]["temp"].stringValue
                let response = CityWeather(cityCountry: cityCountry, cityId: cityId, weatherIcon: weatherIcon, max: max, min: min, now: now)
                completion(response)
            }
            else if response.response!.statusCode == 404 {
                error(cityCountry)
            }
        }
    }
    
    public func getByLatLon(lat: String, lon: String, completion: @escaping (CityWeather) -> Void){
        let url = "\(ENDPOINT)weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)&units=metric&lang=es"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedURL!, method: .get).responseJSON {
          response in
            guard let data = response.value else {return }
            if response.response!.statusCode == 200 {
                let jsonData = JSON(data)
                let cityCountry = jsonData["name"].stringValue
                let cityId = jsonData["id"].stringValue
                let weatherIcon = jsonData["weather"][0]["icon"].stringValue
                let max = jsonData["main"]["temp_max"].stringValue
                let min = jsonData["main"]["temp_min"].stringValue
                let now = jsonData["main"]["temp"].stringValue
                let response = CityWeather(cityCountry: cityCountry, cityId: cityId, weatherIcon: weatherIcon, max: max, min: min, now: now)
                completion(response)
            }
        }
    }
    
    public func getExtendByCityCountry(cityCountry: String, completion: @escaping ([CityWeather]) -> Void){
    let url = "\(ENDPOINT)forecast?q=\(cityCountry)&appid=\(API_KEY)&units=metric&lang=es"
    let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    AF.request(encodedURL!, method: .get).responseJSON {
      response in
          guard let data = response.value else {return }
            var responseArray : [CityWeather] = []
            let jsonData = JSON(data)

            let list = jsonData["list"].arrayValue
            for l in list{
                let cityCountry = cityCountry
                let cityId = l["id"].stringValue
                let weatherIcon = l["weather"][0]["icon"].stringValue
                let max = l["main"]["temp_max"].stringValue
                let min = l["main"]["temp_min"].stringValue
                let now = l["main"]["temp"].stringValue
                let dateTime = l["dt_txt"].stringValue
                let temp = CityWeather(cityCountry: cityCountry, cityId: cityId, weatherIcon: weatherIcon, max: max, min: min, now: now)
                temp.setdateTime(dateTime: dateTime)
                responseArray.append(temp)
            }
          completion(responseArray)
      }
    }
}
