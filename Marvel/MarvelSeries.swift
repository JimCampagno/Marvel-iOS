//
//  MarvelSeries.swift
//  Marvel
//
//  Created by Jim Campagno on 12/3/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import RealmSwift

final class MarvelSeries: Object {
    
    dynamic var id: Int = 0
    dynamic var title: String?
    dynamic var seriesDescription: String?
    dynamic var type: String?
    dynamic var canDownloadImage: Bool = true
    dynamic var thumbnailPath: String?
    dynamic var numberOfCharacters: Int = 0
    dynamic var modified: String?
    dynamic var localImagePath: String? // TODO: Implement
    let marvelCharacters = List<MarvelCharacter>() // TODO: Implement

    dynamic var isDownloadingImage: Bool = false
    var image: UIImage? // TODO: Implement
    
    
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
extension MarvelSeries {
    
    func configure(json: JSON) {
        id = json["id"] as? Int ?? 0
        title = json["title"] as? String
        seriesDescription = json["description"] as? String ?? "No Description"
        type = json["type"] as? String
        thumbnailPath = getThumbnailPath(with: json)
        numberOfCharacters = getNumberOfCharacters(with: json)
        modified = json["modified"] as? String ?? "n/a"
    }
    
    func getThumbnailPath(with dictionary: JSON) -> String? {
        guard let dictionary = dictionary["thumbnail"] as? [String : String] else { return nil }
        let path = dictionary["path"]
        let pathExtension = dictionary["extension"]
        guard let thePath = path, let thePathExt = pathExtension else { return nil }
        if thePath.contains("image_not_available") { canDownloadImage = false }
        return thePath + "." + thePathExt
    }
    
    func getNumberOfCharacters(with dictionary: JSON) -> Int {
        guard let json = dictionary["characters"] as? JSON else { return 0 }
        let available = json["available"] as? Int ?? 0
        return available
    }

}

// MARK: - Download Image Methods
extension MarvelSeries {
    
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
