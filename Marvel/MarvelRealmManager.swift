//
//  MarvelRealmManager.swift
//  Marvel
//
//  Created by Jim Campagno on 12/2/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import RealmSwift


final class MarvelRealmManager {
    
    static let shared = MarvelRealmManager()
    
    lazy var allCharacters: Results<MarvelCharacter> = {
        return self.realm.objects(MarvelCharacter.self)
    }()
    
    lazy var allSeries: Results<MarvelSeries> = {
        return self.realm.objects(MarvelSeries.self)
    }()
    
    var characters: [MarvelCharacter] = [] {
        didSet { characterIDS = Set(characters.map { $0.id }) }
    }
    
    var avengerSeries: [MarvelSeries] = [] {
        didSet { avengerSeriesIDS = Set(avengerSeries.map { $0.id }) }
    }
    
    var characterIDS: Set<Int> = []
    var avengerSeriesIDS: Set<Int> = []
    let realm = try! Realm()
    
    
    private init() { }
    
}

// MARK: - Helper Methods
extension MarvelRealmManager {
    
    fileprivate func getResults(with json: JSON?) -> [JSON]? {
        guard let rawJSON = json,
            let data = rawJSON["data"] as? JSON,
            let results = data["results"] as? [JSON]
            else { return nil }
        return results
    }
    
}

// MARK: - Characters
extension MarvelRealmManager {
    
    func getCharacterNamesBegin(with query: QueryString, ascending: Bool, handler: @escaping (Bool)
        -> Void) {
        let request = MarvelRequest.nameStartsWith(query: query, ascending: ascending)
        
        MarvelAPIManager.shared.get(request: request, handler: { [weak self] success, json in
            DispatchQueue.main.async {
                guard let results = self?.getResults(with: json) else { handler(false); return }
                let theCharacters = self?.createCharacters(with: results) ?? []
                self?.characters.insert(contentsOf: theCharacters, at: 0)
                handler(true)
            }
        })
    }
    
    fileprivate func createCharacters(with array: [JSON]) -> [MarvelCharacter] {
        
        var newCharacters: [MarvelCharacter] = []
        
        for json in array {
            // TODO: Should I grab id from json, check to see if we've already made object first instead of creating new MarvelCharacter no matter what.
            let character = MarvelCharacter()
            character.configure(json: json)
            
            if characterIDS.contains(character.id) {
                continue
            }
            
            if let currentChar = realm.object(ofType: MarvelCharacter.self, forPrimaryKey: character.id) {
                newCharacters.append(currentChar)
            } else {
                try! realm.write { realm.add(character) }
                newCharacters.append(character)
            }
            
        }
        
        return newCharacters
    }
    
    fileprivate func createCharactersForSeries(with array: [JSON]) -> [MarvelCharacter] {
        var newCharacters: [MarvelCharacter] = []
        
        for json in array {
            let character = MarvelCharacter()
            character.configure(json: json)
            newCharacters.append(character)
        }
        return newCharacters
    }
    
}


// MARK: - Series
extension MarvelRealmManager {
    
    func getAvengerSeries(handler: @escaping (Bool) -> Void) {
        getSeries(with: QueryString("Avengers")!) { success in
            DispatchQueue.main.async {
                handler(success)
            }
        }
        
    }
    
    fileprivate func getSeries(with query: QueryString, handler: @escaping (Bool) -> Void) {
        let request = MarvelRequest.series(query: query)
        
        MarvelAPIManager.shared.get(request: request) { [weak self] success, json in
            DispatchQueue.main.async {
                guard let results = self?.getResults(with: json) else { handler(false); return }
                
                self?.createSeries(with: results) { seriesSuccess in
                    DispatchQueue.main.async {
                        handler(seriesSuccess)
                    }
                }
                
            }
        }
        
    }
    
    fileprivate func createSeries(with array: [JSON], handler: @escaping (Bool) -> Void) {
        guard !array.isEmpty else { handler(true); return }
        
        var copy = array
        let json = copy.removeLast()
        
        let series = MarvelSeries()
        series.configure(json: json)
        
        if series.numberOfCharacters == 0 || avengerSeriesIDS.contains(series.id) {
            createSeries(with: copy, handler: handler)
            
        } else {
            getChracters(in: series, limit: 100, offset: 0) { [unowned self] success in
                DispatchQueue.main.async {
                    let seriesExists = self.realm.object(ofType: MarvelSeries.self, forPrimaryKey: series.id)
                    if seriesExists == nil {
                        self.avengerSeries.append(series)
                
                        try! self.realm.write {
                            self.realm.add(series)
                        }
                    }
                    self.createSeries(with: copy, handler: handler)
                }
            }
        }
        
        
    }
    
    fileprivate func getChracters(in series: MarvelSeries, limit: Int, offset: Int?, handler: @escaping (Bool) -> Void) {
        guard let offset = offset else { handler(true); return }
        
        let request = MarvelRequest.seriesCharacters(series: series.id, limit: limit, offset: offset)
        
        MarvelAPIManager.shared.get(request: request) { [unowned self] success, json in
            DispatchQueue.main.async {
                guard let results = self.getResults(with: json) else { handler(false); return }
                let newCharacters = self.createCharactersForSeries(with: results)
                
                for index in newCharacters.indices {
                    let marvelChar = newCharacters[index]
                    
                    if self.characterIDS.contains(marvelChar.id) {
                        if let currentChar = self.realm.object(ofType: MarvelCharacter.self, forPrimaryKey: series.id) {
                            series.marvelCharacters.append(currentChar)
                        }
                        
                    } else {
                        marvelChar.isAvenger = true
                        try! self.realm.write { self.realm.add(marvelChar) }
                        series.marvelCharacters.append(marvelChar)
                        self.characterIDS.insert(marvelChar.id)
                    }
                }
                
                let remainingCharacters = Int(series.numberOfCharacters) - offset
                let newOffset = remainingCharacters > limit ? offset + limit : nil
                self.getChracters(in: series, limit: limit, offset: newOffset, handler: handler)
            }
            
        }
    }
}
