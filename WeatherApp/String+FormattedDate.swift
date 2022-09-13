//
//  String+FormattedDate.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import Foundation

extension String {
    func toStringDate() -> String {
        
        let baseDateFormatter = DateFormatter()
        baseDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = baseDateFormatter.date(from: self) else { return "" }
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "MMM d"
        return toDateFormatter.string(from: date)
    }
}
