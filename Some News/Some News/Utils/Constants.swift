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
}
