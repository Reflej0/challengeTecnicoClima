//
//  CityWeatherRealm.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 08/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CityWeatherRealm: Object {
    
    @objc dynamic var ID = 0
    @objc dynamic var cityCountry = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}
