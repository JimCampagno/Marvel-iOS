//
//  MarvelRequestTests.swift
//  Marvel
//
//  Created by Jim Campagno on 12/1/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import XCTest
@testable import Marvel

class MarvelRequestTests: XCTestCase {
    
    func testCharacterSearch() {
        let query = QueryString("Spider-Man")!
        let request: MarvelRequest = .name(query: query, ascending: true)
        
        // TODO: This needs to be updated to reflect md5 and ts parameters.
        // let url = URL(string: "https://gateway.marvel.com/v1/public/characters?name=Spider-Man&apikey=\(MarvelInfo.publicKey)")
        
        XCTAssertNotNil(request.url, "The Character Search URL should not be nil.")
        // XCTAssertEqual(request.url, url, "The request URL is incorrect.")
    }
    
    
    
}
