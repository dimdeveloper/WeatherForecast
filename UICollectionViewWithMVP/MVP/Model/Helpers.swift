//
//  Helpers.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 03.09.2021.
//

import Foundation

extension Date {
    func getDatestring(stringDate: String) -> String {
        
        let jSONDateFormatter = DateFormatter()
        jSONDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jSONDateFormatter.calendar = Calendar(identifier: .iso8601)
        jSONDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        jSONDateFormatter.locale = Locale(identifier: "uk_UA_POSIX")

        let date: Date = jSONDateFormatter.date(from: stringDate)!

        let aPPDateFormatter = DateFormatter()
        aPPDateFormatter.dateFormat = "MMM dd,yyyy"
        return aPPDateFormatter.string(from: date);
    }
}
