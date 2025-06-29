//
//  Constants.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import Foundation

class BaseENV {
    
    let dict: NSDictionary
    
    init(resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else  { fatalError("Could not find file: \(resourceName).plist") }
        self.dict = plist
    }
}

protocol ApiKeyProtocol {
    var API_KEY: String { get }
}

class DedENV: BaseENV, ApiKeyProtocol {
    
    init() {
        super.init(resourceName: "DEV-Key")
    }
    
    var API_KEY: String {
        dict.object(forKey: "NEWS_KEY") as? String ?? ""
    }
}

class ProdENV: BaseENV, ApiKeyProtocol {
    
    init() {
        super.init(resourceName: "PROD-Key")
    }
    
    var API_KEY: String {
        dict.object(forKey: "NEWS_KEY") as? String ?? ""
    }
}

var ENV: ApiKeyProtocol {
    #if DEBUG
    return DedENV()
    #else
    return ProdENV()
    #endif
}


struct Constants {
    static let endpoint = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(ENV.API_KEY)"
    
    // Date formatting utility
    static func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputFormatter.date(from: dateString) else {
            // Try alternative format without 'Z'
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = inputFormatter.date(from: dateString) else {
                return dateString // Return original if parsing fails
            }
            return formatDateFromDate(date)
        }
        
        return formatDateFromDate(date)
    }
    
    private static func formatDateFromDate(_ date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        // Check if it's today
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "Today at \(formatter.string(from: date))"
        }
        
        // Check if it's yesterday
        if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "Yesterday at \(formatter.string(from: date))"
        }
        
        // Check if it's within the last 7 days
        let daysDifference = calendar.dateComponents([.day], from: date, to: now).day ?? 0
        if daysDifference < 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return "\(formatter.string(from: date))"
        }
        
        // For older dates, show the full date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
