//
//  Int+FormattedDate.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import Foundation

extension Int {
    func toStringDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE h a"
        return dateFormatter.string(from: date)
    }
}
