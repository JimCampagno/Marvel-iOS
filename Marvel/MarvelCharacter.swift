//
//  MarvelCharacter.swift
//  Marvel
//
//  Created by Jim Campagno on 12/2/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import RealmSwift


final class MarvelCharacter: Object {
    
    dynamic var name: String?
    dynamic var id: Int = 0
    dynamic var heroDescription: String?
    dynamic var thumbnailPath: String?
    dynamic var canDownloadImage: Bool = true
    dynamic var modified: String?
    dynamic var isAvenger: Bool = false
    dynamic var localImagePath: String? // TODO: Implement
    let series = LinkingObjects(fromType: MarvelSeries.self, property: "marvelCharacters") // TODO: Implement

    dynamic var isDownloadingImage: Bool = false
    var image: UIImage?
    
    override static func ignoredProperties() -> [String] {
        return ["image", "isDownloadingImage"]
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


// MARK: - Configure Methods
extension MarvelCharacter {
    
    func configure(json: JSON) {
        id = json["id"] as? Int ?? 0
        name = json["name"] as? String
        heroDescription = json["description"] as? String
        modified = json["modified"] as? String ?? "n/a"
        thumbnailPath = generateThumbnailPath(with: json)
    }
    
    func generateThumbnailPath(with dictionary: JSON) -> String? {
        guard let dictionary = dictionary["thumbnail"] as? [String : String] else { return nil }
        let path = dictionary["path"]
        let pathExtension = dictionary["extension"]
        guard let thePath = path, let thePathExt = pathExtension else { return nil }
        if thePath.contains("image_not_available") { canDownloadImage = false }
        return thePath + "." + thePathExt
    }
    
}


// MARK: - Download Image Methods
extension MarvelCharacter {
    
    func downloadImage(handler: @escaping (Bool) -> Void) {
        guard let path = thumbnailPath, let url = URL(string: path) else { handler(false); return }
        isDownloadingImage = true
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let rawData = data, let thumbnailImage = UIImage(data: rawData) else { handler(false); return }
                self?.image = thumbnailImage
                self?.isDownloadingImage = false
                handler(true)
            }
            }.resume()
    }
    
    func setNoImage() {
        image = #imageLiteral(resourceName: "NoImage")
    }
    
}
