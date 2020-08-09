//
//  CitiesService.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 07/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityService{
    
    public func getCountries() -> [String]?{
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                let arr = jsonObj.dictionaryValue.map{ return $0.key }
                return arr.sorted {$0 < $1}
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
    
    public func getCitiesByCountry(country: String) -> [String]? {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                let arr = jsonObj[country].arrayValue.map{ return ($0).stringValue }
                return arr.sorted {$0 < $1}
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
}
