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
    weak var delegate: DetailViewDismissDelegate?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCharacter()
        setupDismissView()
    }
    
    func setupCharacter() {
        characterDetailView.marvelCharacter = marvelCharacter
        characterDetailView.scrollTextViewToTop()
    }
    
    func setupDismissView() {
        let dismissView = UIView(frame: view.frame)
        view.insertSubview(dismissView, belowSubview: characterDetailView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(tapGesture)
    }
    
    func dismissViewController() {
        delegate?.viewWillDismiss()
        dismiss(animated: true, completion: nil)
    }
    
}
