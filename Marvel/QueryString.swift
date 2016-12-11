//
//  QueryString.swift
//  Marvel
//
//  Created by Jim Campagno on 12/2/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation

struct QueryString {
    
    let string: String
    
    init?(_ string: String) {
        guard let escapedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        self.string = escapedString
    }
    
}
