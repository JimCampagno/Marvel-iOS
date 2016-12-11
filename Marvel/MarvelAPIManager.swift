//
//  MarvelAPIManager.swift
//  Marvel
//
//  Created by Jim Campagno on 12/1/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

final class MarvelAPIManager {
    
    static let shared = MarvelAPIManager()
    
    private init() { }
    
    func get(request: MarvelRequest, handler: @escaping (Bool, JSON?) -> Void) {
        guard let url = request.url else { handler(false, nil); return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let rawData = data else { handler(false, nil); return }
                let json = try! JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as! JSON
                print("We have data from internet, returning JSON.")
                handler(true, json)
            }
            
        }.resume()
    }
}

