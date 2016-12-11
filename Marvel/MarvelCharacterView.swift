//
//  MarvelCharacterView.swift
//  Marvel
//
//  Created by Jim Campagno on 12/3/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

protocol MarvelCharacterDelegate: class {
    func canDisplayImage(sender: MarvelCharacter?) -> Bool
}

final class MarvelCharacterView: UIView {
    
    @IBOutlet weak var seriesImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let avengerBorderColor = UIColor(red:0.30, green:0.56, blue:0.87, alpha:1.00).cgColor
    
    weak var delegate: MarvelCharacterDelegate?
    let duration: TimeInterval = 0.8
    
    var marvelCharacter: MarvelCharacter! {
        didSet {
            setupNameLabel()
            setupSeriesImage()
            setupImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MarvelCharacterView", owner: self, options: nil)
        
        // TODO: Create initialstate method.
        nameLabel.alpha = 0.0
        imageView.alpha = 0.0
        seriesImageView.alpha = 0.0
        
        // TODO: Create UIView Extension to handle this constraint.
        backgroundColor = UIColor.clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // TODO: Separate this into another method. Too many magic numbers.
        let paddingSpace: CGFloat = 25 * (2 + 1)
        let width = UIScreen.main.bounds.size.width
        let availableWidth = width - paddingSpace
        let cornerRadius = (availableWidth / 2) / 2
        
        // TODO: Separate this into its own method.
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
    }
    
}


// MARK: - Marvel Character Methods
extension MarvelCharacterView {
    
    func setupNameLabel() {
        updateNameLabel(animated: marvelCharacter.image == nil)
    }
    
    func setupSeriesImage() {
        guard marvelCharacter.isAvenger else { resetToNonAvenger(); return }
        updateSeriesImage(animated: marvelCharacter.image == nil)
    }
    
    func setupImage() {
        guard marvelCharacter.image == nil else { updateImage(animated: false); return }
        
        guard !marvelCharacter.isDownloadingImage else { return }
        
        if !marvelCharacter.canDownloadImage {
            marvelCharacter.setNoImage()
            updateImage(animated: true)
            return
        }
        
        marvelCharacter.downloadImage { [weak self] success in
            guard success, let theDelegate = self?.delegate else { return }
            if theDelegate.canDisplayImage(sender: self?.marvelCharacter) {
                self?.updateImage(animated: true)
            }
        }
    }
    
    func updateNameLabel(animated: Bool = false) {
        nameLabel.alpha = 0.0
        nameLabel.text = marvelCharacter.name
        guard animated else { nameLabel.alpha = 1.0; return }
        UIView.animate(withDuration: duration, animations: {
            self.nameLabel.alpha = 1.0
        })
    }
    
    func updateImage(animated: Bool = false) {
        imageView.alpha = 0.0
        imageView.image = self.marvelCharacter.image
        guard animated else { imageView.alpha = 1.0; return }
        UIView.animate(withDuration: duration, animations: {
            self.imageView.alpha = 1.0
        })
    }
    
    func updateSeriesImage(animated: Bool = false) {
        seriesImageView.alpha = 0.0
        guard animated else { updateToAvenger(); return }
        UIView.animate(withDuration: duration, animations: {
            self.seriesImageView.alpha = 1.0
            self.imageView.layer.borderColor = self.avengerBorderColor
        })
    }
    
}

// MARK: - Helper Methods
extension MarvelCharacterView {
    
    func clearPriorCharacter() {
            alphaZeroAllViews()
            imageView.image = nil
            nameLabel.text = nil
    }
    
    func alphaZeroAllViews() {
            imageView.alpha = 0.0
            nameLabel.alpha = 0.0
            seriesImageView.alpha = 0.0
            
    }
    
    func updateToAvenger() {
        if imageView.layer.borderColor == UIColor.black.cgColor {
            imageView.layer.borderColor = avengerBorderColor
        }
        if seriesImageView.alpha == 0.0 {
            seriesImageView.alpha = 1.0
        }
        
    }
    
    func resetToNonAvenger() {
        if imageView.layer.borderColor != UIColor.black.cgColor {
            imageView.layer.borderColor = UIColor.black.cgColor
        }
        if seriesImageView.alpha != 0.0 {
            seriesImageView.alpha = 0.0
        }
    }
    
}
