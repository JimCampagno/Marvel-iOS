//
//  MarvelSeriesDetailViewModel.swift
//  Marvel
//
//  Created by Jim Campagno on 12/4/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


final class MarvelSeriesDetailViewModel {
    
    let sections = 1
    let heightForCell: CGFloat = 120
    var visibleIndexPaths: [IndexPath] = []
    let marvelSeries: LinkingObjects<MarvelSeries>
    
    var rows: Int {
        print("How many: \(marvelSeries.count)")
        return marvelSeries.count
    }
 
    init(marvelSeries: LinkingObjects<MarvelSeries>) {
        self.marvelSeries = marvelSeries
    }
    
}


// MARK: - Data Source
extension MarvelSeriesDetailViewModel {
    
    func series(at indexPath: IndexPath) -> MarvelSeries {
        return marvelSeries[indexPath.row]
    }
    
    func seriesIsViewable(marvelSeries: MarvelSeries) -> Bool {
        var visibleSeries: Set<Int> = []
        
        for indexPath in visibleIndexPaths {
            visibleSeries.insert(series(at: indexPath).id)
        }
        
        return visibleSeries.contains(marvelSeries.id)
    }
    
}
