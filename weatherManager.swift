//
//  weatherManager.swift
//  Clima
//
//  Created by Maksim Pansevich on 28/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let url = "http://api.openweathermap.org/data/2.5/weather?appid=ca86c5d774a8764190b560bac9b11a25&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        print(urlString)
    }
}
