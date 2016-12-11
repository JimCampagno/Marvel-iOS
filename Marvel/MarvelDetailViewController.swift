//
//  MarvelDetailViewController.swift
//  Marvel
//
//  Created by Jim Campagno on 12/5/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

class MarvelDetailViewController: UIViewController {

    @IBOutlet weak var characterDetailView: CharacterDetailView!

    var marvelCharacter: MarvelCharacter!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        characterDetailView.marvelCharacter = marvelCharacter

        let dismissView = UIView(frame: view.frame)
        view.insertSubview(dismissView, belowSubview: characterDetailView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(tapGesture)
        
        characterDetailView.scrollTextViewToTop()
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
