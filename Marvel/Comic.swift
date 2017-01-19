//
//  Comic.swift
//  Marvel
//
//  Created by Jim Campagno on 12/31/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import Foundation
import RealmSwift

final class Comic: Object {
    
    dynamic var id: Int = 0
    dynamic var digitalId: Int = 0
    dynamic var title: String = ""
    dynamic var issueNumber: Int = 0
    dynamic var comicDescription: String = ""
    dynamic var canDownloadImage: Bool = true
    dynamic var thumbnailPath: String?
    
    // Ignored
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
extension Comic {
    
    func configure(json: JSON) {
        id = json["id"] as? Int ?? id
        digitalId = json["digitalId"] as? Int ?? 0
        title = json["title"] as? String ?? title
        issueNumber = json["issueNumber"] as? Int ?? 0
        comicDescription = json["description"] as? String ?? comicDescription
        thumbnailPath = getThumbnailPath(with: json)
    }
    
    func getThumbnailPath(with dictionary: JSON) -> String? {
        guard let dictionary = dictionary["thumbnail"] as? [String : String] else { return nil }
        let path = dictionary["path"]
        let pathExtension = dictionary["extension"]
        guard let thePath = path, let thePathExt = pathExtension else { return nil }
        if thePath.contains("image_not_available") { canDownloadImage = false }
        return thePath + "." + thePathExt
    }
    
}

// MARK: - Download Image Methods
extension Comic {
    
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
    
    
}


/*
{
    "code": 200,
    "status": "Ok",
    "copyright": "© 2016 MARVEL",
    "attributionText": "Data provided by Marvel. © 2016 MARVEL",
    "attributionHTML": "<a href=\"http://marvel.com\">Data provided by Marvel. © 2016 MARVEL</a>",
    "etag": "3fa832830485e4364aa6f1d1993334886a0beb53",
    "data": {
        "offset": 0,
        "limit": 5,
        "total": 42,
        "count": 5,
        "results": [
        {
        "id": 57333,
        "digitalId": 0,
        "title": "Web Warriors (2015) #8",
        "issueNumber": 8,
        "variantDescription": "",
        "description": "The Web of Life and Destiny is damaged, and even worse – it’s getting TANGLED! How are the Web Warriors supposed to repair REALITY ITSELF?! Join us for this insane web-hopping romp that features A GIANT SPIDER-MAN ROBOT FROM THE FURTHEST CORNER OF THE MULTIVERSE AS A GUEST STAR!\n",
        "modified": "2016-06-10T17:44:20-0400",
        "isbn": "",
        "upc": "759606083641000811",
        "diamondCode": "APR160945",
        "ean": "",
        "issn": "",
        "format": "Comic",
        "pageCount": 32,
        "textObjects": [
        {
        "type": "issue_solicit_text",
        "language": "en-us",
        "text": "The Web of Life and Destiny is damaged, and even worse – it’s getting TANGLED! How are the Web Warriors supposed to repair REALITY ITSELF?! Join us for this insane web-hopping romp that features A GIANT SPIDER-MAN ROBOT FROM THE FURTHEST CORNER OF THE MULTIVERSE AS A GUEST STAR!\n"
        }
        ],
        "resourceURI": "http://gateway.marvel.com/v1/public/comics/57333",
        "urls": [
        {
        "type": "detail",
        "url": "http://marvel.com/comics/issue/57333/web_warriors_2015_8?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "purchase",
        "url": "http://comicstore.marvel.com/Web-Warriors-8/digital-comic/41839?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        }
        ],
        "series": {
        "resourceURI": "http://gateway.marvel.com/v1/public/series/20900",
        "name": "Web Warriors (2015 - Present)"
        },
        "variants": [],
        "collections": [],
        "collectedIssues": [],
        "dates": [
        {
        "type": "onsaleDate",
        "date": "2016-06-22T00:00:00-0400"
        },
        {
        "type": "focDate",
        "date": "2016-06-08T00:00:00-0400"
        }
        ],
        "prices": [
        {
        "type": "printPrice",
        "price": 3.99
        }
        ],
        "thumbnail": {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/4/30/575b345f6792e",
        "extension": "jpg"
        },
        "images": [
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/4/30/575b345f6792e",
        "extension": "jpg"
        }
        ],
        "creators": {
        "available": 4,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/57333/creators",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/9799",
        "name": "David Baldeon",
        "role": "writer"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/12452",
        "name": "Mike Costa",
        "role": "writer"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/12457",
        "name": "Edward Devin Lewis",
        "role": "editor"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/11488",
        "name": "Julian Totino Tedesco",
        "role": "penciller (cover)"
        }
        ],
        "returned": 4
        },
        "characters": {
        "available": 4,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/57333/characters",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009157",
        "name": "Spider-Girl (Anya Corazon)"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009609",
        "name": "Spider-Girl (May Parker)"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011347",
        "name": "Spider-Ham (Larval Earth)"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1012295",
        "name": "Spider-Man (Noir)"
        }
        ],
        "returned": 4
        },
        "stories": {
        "available": 2,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/57333/stories",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/stories/125483",
        "name": "cover from Web Warriors (2015) #8",
        "type": "cover"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/stories/125484",
        "name": "story from Web Warriors (2015) #8",
        "type": "interiorStory"
        }
        ],
        "returned": 2
        },
        "events": {
        "available": 0,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/57333/events",
        "items": [],
        "returned": 0
        }
        },
        {
        "id": 39713,
        "digitalId": 23719,
        "title": "Spider-Island: The Amazing Spider-Girl (2011) #3",
        "issueNumber": 3,
        "variantDescription": "",
        "description": "SPIDER-ISLAND TIE-IN! Caught in a war between The Kingpin, The Society of Wasps and a Manhattan infested by Spiders, Anya Corazon buckles down to protect her own!\n",
        "modified": "2014-12-29T10:03:42-0500",
        "isbn": "",
        "upc": "5960607666-00311",
        "diamondCode": "AUG110603",
        "ean": "",
        "issn": "",
        "format": "Comic",
        "pageCount": 32,
        "textObjects": [
        {
        "type": "issue_solicit_text",
        "language": "en-us",
        "text": "SPIDER-ISLAND TIE-IN! THIS IS IT - THE BIGGEST DECISION IN SPIDER-GIRL'S LIFE! Caught in a war between The Kingpin, The Society of Wasps and a Manhattan infested by Spiders, Anya Corazon buckles down to protect her own - and will make a decision at the end of this story that will forever change Spider-Girl!  Paul Tobin (SPIDER-GIRL) and Pepe Larraz (WEB OF SPIDER-MAN) bring you this fight-filled, web-walloping, death-defying tale to its rollicking conclusion!"
        },
        {
        "type": "issue_preview_text",
        "language": "en-us",
        "text": "SPIDER-ISLAND TIE-IN! Caught in a war between The Kingpin, The Society of Wasps and a Manhattan infested by Spiders, Anya Corazon buckles down to protect her own!\n"
        }
        ],
        "resourceURI": "http://gateway.marvel.com/v1/public/comics/39713",
        "urls": [
        {
        "type": "detail",
        "url": "http://marvel.com/comics/issue/39713/spider-island_the_amazing_spider-girl_2011_3?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "purchase",
        "url": "http://comicstore.marvel.com/Spider-Island-The-Amazing-Spider-Girl-3/digital-comic/23719?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "reader",
        "url": "http://marvel.com/digitalcomics/view.htm?iid=23719&utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "inAppLink",
        "url": "https://applink.marvel.com/issue/23719?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        }
        ],
        "series": {
        "resourceURI": "http://gateway.marvel.com/v1/public/series/14655",
        "name": "Spider-Island: The Amazing Spider-Girl (2011)"
        },
        "variants": [],
        "collections": [],
        "collectedIssues": [],
        "dates": [
        {
        "type": "onsaleDate",
        "date": "2011-10-26T00:00:00-0400"
        },
        {
        "type": "focDate",
        "date": "2011-10-11T00:00:00-0400"
        },
        {
        "type": "unlimitedDate",
        "date": "2012-09-12T00:00:00-0400"
        },
        {
        "type": "digitalPurchaseDate",
        "date": "2011-10-26T00:00:00-0400"
        }
        ],
        "prices": [
        {
        "type": "printPrice",
        "price": 2.99
        },
        {
        "type": "digitalPurchasePrice",
        "price": 1.99
        }
        ],
        "thumbnail": {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/d/10/56b37ebe896ea",
        "extension": "jpg"
        },
        "images": [
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/d/10/56b37ebe896ea",
        "extension": "jpg"
        },
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/b0/4eaaf990b639c",
        "extension": "jpg"
        },
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/a0/4e7cbc873e307",
        "extension": "jpg"
        },
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/6/70/4e7cbc6406644",
        "extension": "jpg"
        },
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/d0/4e7cbc25ee496",
        "extension": "jpg"
        }
        ],
        "creators": {
        "available": 4,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/39713/creators",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/11595",
        "name": "Alejandro Garza",
        "role": "penciller (cover)"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/10144",
        "name": "Pepe Larraz",
        "role": "penciller"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/8027",
        "name": "Andres Mossa",
        "role": "colorist"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/4983",
        "name": "Paul Tobin",
        "role": "writer"
        }
        ],
        "returned": 4
        },
        "characters": {
        "available": 1,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/39713/characters",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009157",
        "name": "Spider-Girl (Anya Corazon)"
        }
        ],
        "returned": 1
        },
        "stories": {
        "available": 2,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/39713/stories",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/stories/90137",
        "name": "Spider-Island: The Amazing Spider-Girl (2011) #3",
        "type": "cover"
        },
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/stories/90138",
        "name": "Spider-Island: The Amazing Spider-Girl (2011) #3",
        "type": "interiorStory"
        }
        ],
        "returned": 2
        },
        "events": {
        "available": 1,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/39713/events",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/events/305",
        "name": "Spider-Island"
        }
        ],
        "returned": 1
        }
        },
        {
        "id": 39714,
        "digitalId": 23720,
        "title": "Spider-Island: The Amazing Spider-Girl (2011) #2",
        "issueNumber": 2,
        "variantDescription": "",
        "description": "SPIDER-ISLAND TIE-IN\nAs the Society of the Wasps mobilizes an army to put a permanent end to ALL spiders, Spider-Girl to fight side-by-side with the Kingpin! But if Spider-Girl is Kingpin's enforcer, where does that leave the Hobgoblin, and will he prove the deadliest threat of all? Paul Tobin (SPIDER-GIRL) and Pepe Larraz (WEB OF SPIDER-MAN) bring the battle of the bugs!",
        "modified": "2014-12-29T10:03:42-0500",
        "isbn": "",
        "upc": "5960607666-00211",
        "diamondCode": "JUL110625",
        "ean": "",
        "issn": "",
        "format": "Comic",
        "pageCount": 32,
        "textObjects": [
        {
        "type": "issue_solicit_text",
        "language": "en-us",
        "text": "SPIDER-ISLAND TIE-IN\nAs the Society of the Wasps mobilizes an army to put a permanent end to ALL spiders, Spider-Girl to fight side-by-side with the Kingpin! But if Spider-Girl is Kingpin's enforcer, where does that leave the Hobgoblin, and will he prove the deadliest threat of all? Paul Tobin (SPIDER-GIRL) and Pepe Larraz (WEB OF SPIDER-MAN) bring the battle of the bugs!"
        }
        ],
        "resourceURI": "http://gateway.marvel.com/v1/public/comics/39714",
        "urls": [
        {
        "type": "detail",
        "url": "http://marvel.com/comics/issue/39714/spider-island_the_amazing_spider-girl_2011_2?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "purchase",
        "url": "http://comicstore.marvel.com/Spider-Island-The-Amazing-Spider-Girl-2/digital-comic/23720?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "reader",
        "url": "http://marvel.com/digitalcomics/view.htm?iid=23720&utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        },
        {
        "type": "inAppLink",
        "url": "https://applink.marvel.com/issue/23720?utm_campaign=apiRef&utm_source=4f81b8ca2d96cd1c9212d53014da727a"
        }
        ],
        "series": {
        "resourceURI": "http://gateway.marvel.com/v1/public/series/14655",
        "name": "Spider-Island: The Amazing Spider-Girl (2011)"
        },
        "variants": [],
        "collections": [],
        "collectedIssues": [],
        "dates": [
        {
        "type": "onsaleDate",
        "date": "2011-09-14T00:00:00-0400"
        },
        {
        "type": "focDate",
        "date": "2011-08-30T00:00:00-0400"
        },
        {
        "type": "unlimitedDate",
        "date": "2012-09-12T00:00:00-0400"
        },
        {
        "type": "digitalPurchaseDate",
        "date": "2011-09-14T00:00:00-0400"
        }
        ],
        "prices": [
        {
        "type": "printPrice",
        "price": 2.99
        },
        {
        "type": "digitalPurchasePrice",
        "price": 1.99
        }
        ],
        "thumbnail": {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/40/56b26dd405337",
        "extension": "jpg"
        },
        "images": [
        {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/40/56b26dd405337",
        "extension": "jpg"
        }
        ],
        "creators": {
        "available": 8,
        "collectionURI": "http://gateway.marvel.com/v1/public/comics/39714/creators",
        "items": [
        {
        "resourceURI": "http://gateway.marvel.com/v1/public/creators/11647",
        "name": "Tom Brennan",
        "role": "editor"
 
 */
