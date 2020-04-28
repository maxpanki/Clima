//
//  weatherManager.swift
//  Clima
//
//  Created by Maksim Pansevich on 28/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=ca86c5d774a8764190b560bac9b11a25&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func  parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let temp = decodedData.main.temp
            let weatherID = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(weatherID: weatherID, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
