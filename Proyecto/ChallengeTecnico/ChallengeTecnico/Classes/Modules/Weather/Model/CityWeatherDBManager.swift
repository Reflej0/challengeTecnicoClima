//
//  CityWeatherDBManager.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 08/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.

import UIKit
import RealmSwift

class CityWeatherDBManager {
    
    private var database:Realm
    static let sharedInstance = CityWeatherDBManager()
    
    private init() {
        
        database = try! Realm()
        
    }
    
    func getDataFromDB() -> Results<CityWeatherRealm> {
        
        let results: Results<CityWeatherRealm> = database.objects(CityWeatherRealm.self)
        return results
    }
    
    func addData(object: CityWeatherRealm) {
        
        try! database.write {
            database.add(object)
            print("Added new object")
        }
    }
    
    func new(cityCountry: String){
        let object = CityWeatherRealm()
        object.ID = self.getDataFromDB().count
        object.cityCountry = cityCountry
        try! database.write {
            database.add(object)
            print("Added new object")
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: CityWeatherRealm) {
        
        try! database.write {
            
            database.delete(object)
        }
    }
    
    func deleteFromDbByCityCountry(cityCountry: String) {
         do {
             let realm = try Realm()
             let object = database.objects(CityWeatherRealm.self).filter("cityCountry = %@", cityCountry).first

             try! realm.write {
                 if let obj = object {
                     realm.delete(obj)
                 }
             }
         } catch let error as NSError {
             print("error - \(error.localizedDescription)")
         }
     }
     
}

