//
//  MarvelCollectionViewController.swift
//  Marvel
//
//  Created by Jim Campagno on 12/2/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit


final class MarvelCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    var backgroundImageView: UIImageView!
    var initialLoad: Bool = true
    
    lazy var viewModel: MarvelCollectionViewModel = { [unowned self] in
        return MarvelCollectionViewModel(searchResult: self.searchResult, showDetails: self.showDetails)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMarvelBackground()
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MarvelRealmManager.shared.allCharacters.isEmpty {
            
            // TODO: Throw up loading screen
            MarvelRealmManager.shared.getAvengerSeries() { success in
                
            }
            
        }
        
        
    }
    
    func createMarvelBackground() {
        backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        collectionView?.backgroundView = backgroundImageView
        backgroundImageView.image = #imageLiteral(resourceName: "BlurBackground")
    }
    
    func animateBackgroundView() {
        UIView.transition(with: backgroundImageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.backgroundImageView.image = #imageLiteral(resourceName: "MarvelBackground")
        }, completion: { _ in })
    }
    
}

// MARK: - View Model Callbacks
extension MarvelCollectionViewController {
    
    func searchResult(success: Bool) {
        
        if success {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        } else {
            // TODO: Handle bad search.
            print("Bad search result.")
        }
    }
    
    func showDetails(forCharacter character: MarvelCharacter) {
        performSegue(withIdentifier: viewModel.detailSegueIdentifier, sender: character)
    }
    
}

// MARK: - Segue Methods
extension MarvelCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.handle(segue: segue, withSender: sender)
    }
    
}

// MARK: - UICollectionView DataSource
extension MarvelCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as! MarvelCharacterCollectionViewCell
        if cell.marvelCharacterView.delegate == nil { cell.marvelCharacterView.delegate = self }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let marvelCell = cell as! MarvelCharacterCollectionViewCell
        marvelCell.marvelCharacter = viewModel.character(at: indexPath)
    }
    
}


// MARK: - UICollectionView Delegate FlowLayout
extension MarvelCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.generateItemSize(with: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.sectionInsets.left
    }
    
}

// MARK: - Marvel Character Delegate
extension MarvelCollectionViewController: MarvelCharacterDelegate {
    
    func canDisplayImage(sender: MarvelCharacter?) -> Bool {
        guard let theSender = sender else { return false }
        viewModel.visibleIndexPaths = collectionView?.indexPathsForVisibleItems ?? []
        return viewModel.characterIsViewable(marvelCharacter: theSender)
    }
    
}


// MARK: - UICollectionView Delegate
extension MarvelCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return viewModel.showDetailsOfCharacter(at: indexPath)
    }
    
}

// MARK: - UITextField Delegate
extension MarvelCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if initialLoad {
            animateBackgroundView()
            initialLoad = false
        }
        textField.resignFirstResponder()
        let query = textField.text
        textField.text = nil
        
        collectionView?.resetScrollPositionToTop()
        
        let indexPaths = collectionView?.indexPathsForVisibleItems ?? []
        
        for indexPath in indexPaths {
            let cell = collectionView?.cellForItem(at: indexPath) as! MarvelCharacterCollectionViewCell
            cell.marvelCharacterView.clearPriorCharacter()
        }
        
        return viewModel.search(with: query)
    }
    
}

// MARK: - UIScrollView Extension
extension UIScrollView {
    
    func resetScrollPositionToTop() {
        setContentOffset(CGPoint(x: -contentInset.left, y: -contentInset.top), animated: true)
    }
}

