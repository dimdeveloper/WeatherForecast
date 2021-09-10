//
//  CurrentConditionForecastModel.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 06.09.2021.
//

import Foundation

 // request URL "http://dataservice.accuweather.com/currentconditions/v1/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&details=true"

public struct CurrentConditionModel {
    let temperature: String
    let humidity: String
    let wind: String
    let currentConditionTitle: String
}

struct CurrentConditionReturnObjects: Codable {
    let dayOrNight: Bool
    let icon: Int32
    let temperature: CurrentTemperature
    let wind: Wind
    let humidity: Int32
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case dayOrNight = "IsDayTime"
        case icon = "WeatherIcon"
        case temperature = "Temperature"
        case wind = "Wind"
        case humidity = "RelativeHumidity"
        case text = "WeatherText"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.dayOrNight = try valueContainer.decode(Bool.self, forKey: CodingKeys.dayOrNight)
        self.humidity = try valueContainer.decode(Int32.self, forKey: CodingKeys.humidity)
        self.icon = try valueContainer.decode(Int32.self, forKey: CodingKeys.icon)
       self.temperature = try valueContainer.decode(CurrentTemperature.self, forKey: CodingKeys.temperature)
        self.text = try valueContainer.decode(String.self, forKey: CodingKeys.text)
        self.wind = try valueContainer.decode(Wind.self, forKey: CodingKeys.wind)
        
    }
}
struct CurrentTemperature: Codable {
    let metric: Metric

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }

        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.metric = try valueContainer.decode(Metric.self, forKey: CodingKeys.metric)
        }

}
struct Metric: Codable {
    let value: Double

    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }

        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
        }

}
struct Wind: Codable {
    let direction: DegreesValue
    let speed: SpeedObject
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.direction = try valueContainer.decode(DegreesValue.self, forKey: CodingKeys.direction)
        self.speed = try valueContainer.decode(SpeedObject.self, forKey: CodingKeys.speed)
    }

}
struct SpeedObject: Codable {
    let metric: SpeedValue
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.metric = try valueContainer.decode(SpeedValue.self, forKey: CodingKeys.metric)
    }
    
}
struct SpeedValue: Codable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
    }
}

struct DegreesValue: Codable {
    let degrees: Int32
    
    enum CodingKeys: String, CodingKey {
        case degrees = "Degrees"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.degrees = try valueContainer.decode(Int32.self, forKey: CodingKeys.degrees)
    }
}




extension CurrentConditionReturnObjects {
    static func fetchCurrentConditions(completion: @escaping(CurrentConditionModel) -> Void) {
        print("FetchingCurrentConditions")
        let url = URL(string: "http://dataservice.accuweather.com/currentconditions/v1/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&details=true")!
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let currentConditions = try? jsonDecoder.decode([CurrentConditionReturnObjects].self, from: data) {
                let currentCondition = currentConditions[0]
                let temperature = String(currentCondition.temperature.metric.value)
                let humidity = String(currentCondition.humidity)
                let dayOrnight = currentCondition.dayOrNight
                let windSpeed = String(currentCondition.wind.speed.metric.value)
                let title = currentCondition.text
                let currentConditionModel = CurrentConditionModel(temperature: temperature, humidity: humidity, wind: windSpeed, currentConditionTitle: title)
                completion(currentConditionModel)
            }
            else {
                print("Error")
            }
            
        }
        task.resume()
    }
}
