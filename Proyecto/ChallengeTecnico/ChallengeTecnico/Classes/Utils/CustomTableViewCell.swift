//
//  CustomTableViewCell.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 08/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var labelCityCountry: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelMax: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    @IBOutlet weak var labelNow: UILabel!
    var city: CityWeather?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setWeather(city: CityWeather){
        self.labelCityCountry.text = city.cityCountry
        self.labelMax.text = city.max + "°c"
        self.labelMin.text = city.min + "°c"
        self.labelNow.text = city.now + "°c"
        self.city = city
        self.imageWeather.image = UIImage(named: city.weatherIcon)
        if (city.dateTime != nil) {
            self.labelDateTime.text = city.dateTime
            self.labelDateTime.isHidden = false
        }
        else{
            self.labelDateTime.isHidden = true
        }
    }
    
}
