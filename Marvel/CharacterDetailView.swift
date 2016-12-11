//
//  CharacterDetailView.swift
//  Marvel
//
//  Created by Jim Campagno on 12/5/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

class CharacterDetailView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var marvelNameLabel: UILabel!
    @IBOutlet weak var marvelImageView: UIImageView!
    @IBOutlet weak var marvelTextView: UITextView!
    @IBOutlet weak var marvelLogoImageView: UIImageView!
    
   //  UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.00)
    
    var marvelCharacter: MarvelCharacter! {
        didSet {
            basicSetup()
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
        Bundle.main.loadNibNamed("CharacterDetailView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        marvelImageView.layer.cornerRadius = 10.0
        marvelImageView.layer.masksToBounds = true
        marvelImageView.layer.borderWidth = 2.0
        marvelImageView.layer.borderColor = UIColor.black.cgColor
        marvelTextView.layer.cornerRadius = 15.0
        marvelTextView.layer.masksToBounds = true
        marvelTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
}

// MARK: - Setup Functions
extension CharacterDetailView {
    
    func basicSetup() {
        marvelNameLabel.alpha = 0.0
        marvelImageView.alpha = 0.0
        marvelTextView.alpha = 0.0
        marvelLogoImageView.alpha = 0.0
        
        marvelTextView.text = marvelCharacter.heroDescription
        marvelNameLabel.text = marvelCharacter.name
        marvelImageView.image = marvelCharacter.image
        marvelLogoImageView.image = marvelCharacter.isAvenger ? #imageLiteral(resourceName: "AvengersBlueLogo") : #imageLiteral(resourceName: "MarvelLogo")
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.marvelNameLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.marvelImageView.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .transitionCrossDissolve, animations: {
            self.marvelLogoImageView.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .transitionCrossDissolve, animations: {
            self.marvelTextView.alpha = 1.0
        }, completion: nil)
        
    }
    
    func scrollTextViewToTop() {
        marvelTextView.scrollsToTop = true
        let contentHeight = marvelTextView.contentSize.height
        let offSet = marvelTextView.contentOffset.x
        let contentOffset = contentHeight - offSet
        marvelTextView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
    
}


// MARK: - UIView Extension
extension UIView {
    
    func constrainEdges(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
}
