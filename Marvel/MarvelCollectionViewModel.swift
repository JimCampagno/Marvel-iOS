//
//  MarvelCollectionViewModel.swift
//  Marvel
//
//  Created by Jim Campagno on 12/2/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

typealias SearchResultClosure = (Bool) -> Void
typealias ShowDetailsClosure = (MarvelCharacter) -> Void
typealias DetailViewDismissClosure = () -> Void

protocol DetailViewDismissDelegate: class {
    func viewWillDismiss()
}

final class MarvelCollectionViewModel {
    
    fileprivate let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
    let sections = 1
    let searchResult: SearchResultClosure
    let showDetails: ShowDetailsClosure
    let detailViewDismiss: DetailViewDismissClosure
    var visibleIndexPaths: [IndexPath] = []
    let avengerSegueIdentifier = "AvengerDetailSegue"
    let detailSegueIdentifier = "DetailSegue"
    let reuseIdentifier = "MarvelCell"
    
    var rows: Int {
        return MarvelRealmManager.shared.characters.count
    }
    
    var characters: [MarvelCharacter] {
        return MarvelRealmManager.shared.characters
    }
    
    init(searchResult: @escaping SearchResultClosure, showDetails: @escaping ShowDetailsClosure, detailViewDismiss: @escaping DetailViewDismissClosure) {
        self.searchResult = searchResult
        self.showDetails = showDetails
        self.detailViewDismiss = detailViewDismiss
    }
    
}


// MARK: - Search & Selection Methods
extension MarvelCollectionViewModel {
    
    func search(with string: String?) -> Bool {
        guard let searchTerm = string,
            let query = QueryString(searchTerm)
            else { searchResult(false); return true }
        
        MarvelRealmManager.shared.getCharacterNamesBegin(with: query, ascending: true) { [weak self] success in
            DispatchQueue.main.async {
                self?.searchResult(success)
            }
        }
        
        return true
    }
    
    func showDetailsOfCharacter(at indexPath: IndexPath) -> Bool {
        let character = characters[indexPath.row]
        showDetails(character)
        return true
    }
    
}

// MARK: DetailViewDismiss Delegate
extension MarvelCollectionViewModel: DetailViewDismissDelegate {
    
    func viewWillDismiss() {
        detailViewDismiss()
    }
    
}

// MARK: - Segue Methods
extension MarvelCollectionViewModel {
    
    func handle(segue: UIStoryboardSegue, withSender sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        let chosenCharacter = sender as! MarvelCharacter

        switch segueIdentifier {
            
        case avengerSegueIdentifier:
            let destVC = segue.destination as! MarvelSeriesDetailViewController
            destVC.marvelSeries = chosenCharacter.series
            
        case detailSegueIdentifier:
            let destVC = segue.destination as! MarvelDetailViewController
            destVC.delegate = self
            destVC.marvelCharacter = chosenCharacter

        default:
            fatalError("No such segue identifier: \(segue.identifier)")
        }
        
    }
    
}


// MARK: - Data Source
extension MarvelCollectionViewModel {
    
    func character(at indexPath: IndexPath) -> MarvelCharacter {
        return characters[indexPath.row]
    }
    
    func characterIsViewable(marvelCharacter: MarvelCharacter) -> Bool {
        var visibleCharacters: Set<Int> = []
        
        // print("Visible Index Paths: \(visibleIndexPaths)")
        
        for indexPath in visibleIndexPaths {
            visibleCharacters.insert(character(at: indexPath).id)
        }
        
        // print("\(marvelCharacter.name!): \(visibleCharacters.contains(marvelCharacter.id!))\n")
        
        return visibleCharacters.contains(marvelCharacter.id)
    }
}


// MARK: - Flow Layout
extension MarvelCollectionViewModel {
    
    func generateItemSize(with width: CGFloat) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = width - paddingSpace
        let width = availableWidth / itemsPerRow
        let height = width + 48.0 // 48.0 is height of label in character view.
        return CGSize(width: width, height: height)
    }
    
}


