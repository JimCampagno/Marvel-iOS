//
//  MarvelCharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Jim Campagno on 12/3/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

class MarvelCharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var marvelCharacterView: MarvelCharacterView!
    
    var marvelCharacter: MarvelCharacter! {
        didSet {
            marvelCharacterView.marvelCharacter = marvelCharacter
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        marvelCharacterView.clearPriorCharacter()
    }

}
