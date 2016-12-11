//
//  MarvelRequest.swift
//  Marvel
//
//  Created by Jim Campagno on 12/1/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation

enum MarvelRequest {
    
    static let baseURL: String = "https://gateway.marvel.com/" + "v1/public/"
    static let apiKey: String = "&apikey=\(MarvelInfo.publicKey)"
    
    case name(query: QueryString, ascending: Bool)
    case nameStartsWith(query: QueryString, ascending: Bool)
    case series(query: QueryString)
    case seriesCharacters(series: Int, limit: Int, offset: Int)
    
    var url: URL? {
        switch self {
            
        case let .name(query, ascending):
            return generateURL(withParameter: "characters?name=\(query.string)&orderBy=\(ascending ? "" : "-")name")
            
        case let .nameStartsWith(query, ascending):
            return generateURL(withParameter: "characters?nameStartsWith=\(query.string)&orderBy=\(ascending ? "" : "-")name")
            
        case let .series(query):
            return generateURL(withParameter: "series?title=\(query.string)")
            
        case let .seriesCharacters(series, limit, offset):
            return generateURL(withParameter: "series/\(series)/characters?limit=\(limit)&offset=\(offset)")

        }
    }
    
}

// MARK: - Helper Functions
extension MarvelRequest {
    
    func generateURL(withParameter parameter: String) -> URL? {
        guard let newHash = hash else { return nil }
        let string = MarvelRequest.baseURL + parameter + "&ts=\(newHash.ts)" + MarvelRequest.apiKey + "&hash=\(newHash.md5)"
        return URL(string: string)
    }
    
    var hash: (ts: String, md5: String)? {
        let ts = UUID().uuidString
        let hashString = ts + MarvelInfo.privateKey + MarvelInfo.publicKey
        guard let hash = String.MD5(hashString) else { return nil }
        return (ts, hash)
    }
    
}

// MARK: - MD5 String Extension
extension String {
    // Borrowed from jstn
    // http://stackoverflow.com/a/25136254/4423700
    static func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
