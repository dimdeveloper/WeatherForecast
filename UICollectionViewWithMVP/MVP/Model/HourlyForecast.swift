//
//  hourlyForecast.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 08.09.2021.
//

import Foundation

struct HourlyForecast {
    let time: String
    let weatherIcon: String
    let title: String
    let hasPrecipitation: Bool
    let isDayLight: Bool
    let temperature: String
}

struct HourlyForecastModel: Codable {
    let time: String
    let weatherIcon: Int32
    let title: String
    let hasPrecipitation: Bool
    let isDayLight: Bool
    let temperature: CurrentConditionTemperature
    
    enum CodingKeys: String, CodingKey {
        case time = "DateTime"
        case weatherIcon = "WeatherIcon"
        case title = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case isDayLight = "IsDaylight"
        case temperature = "Temperature"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try valueContainer.decode(String.self, forKey: CodingKeys.time)
        self.weatherIcon = try valueContainer.decode(Int32.self, forKey: CodingKeys.weatherIcon)
       self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
       self.hasPrecipitation = try valueContainer.decode(Bool.self, forKey: CodingKeys.hasPrecipitation)
        self.isDayLight = try valueContainer.decode(Bool.self, forKey: CodingKeys.isDayLight)
        self.temperature = try valueContainer.decode(CurrentConditionTemperature.self, forKey: CodingKeys.temperature)
        
    }
}
struct CurrentConditionTemperature: Codable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
        }
    
}

extension HourlyForecastModel {
  static  func fetchHourlyForecast(completion: @escaping([HourlyForecast]) -> Void){
        let url = URL(string: "http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&metric=true")!
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let hourlyForecast = try? jsonDecoder.decode([HourlyForecastModel].self, from: data) {
                var hourlyForecastArray: [HourlyForecast] = []
                for hourForecast in hourlyForecast {
                    let time = hourForecast.time
                    let weatherIcon = String(hourForecast.weatherIcon)
                    let title = hourForecast.title
                    let hasPrecipitation = hourForecast.hasPrecipitation
                    let isDayLight = hourForecast.isDayLight
                    let temperature = String(hourForecast.temperature.value)
                    let hourForecastModel = HourlyForecast(time: time, weatherIcon: weatherIcon, title: title, hasPrecipitation: hasPrecipitation, isDayLight: isDayLight, temperature: temperature)
                    hourlyForecastArray.append(hourForecastModel)
                }
                completion(hourlyForecastArray)
            } else {
                print("error")
            }
            
        }
        task.resume()
    }
}
