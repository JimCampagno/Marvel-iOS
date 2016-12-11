//
//  MarvelSeriesDetailViewController.swift
//  Marvel
//
//  Created by Jim Campagno on 12/4/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit
import RealmSwift

class MarvelSeriesDetailViewController: UIViewController {
    
    @IBOutlet weak var marvelSeriesView: AvengerSeriesView!
    
    var marvelSeries: LinkingObjects<MarvelSeries>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        marvelSeriesView.marvelSeries = marvelSeries
        
        let dismissView = UIView(frame: view.frame)
        view.insertSubview(dismissView, belowSubview: marvelSeriesView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(tapGesture)
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
