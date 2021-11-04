//
//  CitySearch.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 24.09.2021.
//

import Foundation


struct City: Codable {
    let key: String
    let cityName: String

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case cityName = "LocalizedName"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try valueContainer.decode(String.self, forKey: CodingKeys.key)
        self.cityName = try valueContainer.decode(String.self, forKey: CodingKeys.cityName)
    }
}
extension City {
    static func fetchCities(searchText: String?, completion: @escaping([City]) -> Void) {
        guard let searchPhrase = searchText?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed) else {return}
        let url = "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=G2egayihsSz2c5sAyKJkQqC9YDABCIUj&q=" + searchPhrase + "&language=uk-UA"
        print(url)
        let searchURL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: searchURL) { (data, responce, error) in
            if let data = data, let cities = try? JSONDecoder().decode([City].self, from: data) {
                completion(cities)
            }
        }
        task.resume()
    }
}
