//
//  weatherManager.swift
//  Clima
//
//  Created by Maksim Pansevich on 28/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=ca86c5d774a8764190b560bac9b11a25&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func  parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let temp = decodedData.main.temp
            let weatherID = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(weatherID: weatherID, cityName: name, temperature: temp)
            
            print(weather.conditionName)
        } catch {
            print(error)
        }
    }
}
