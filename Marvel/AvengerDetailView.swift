//
//  AvengerDetailView.swift
//  Marvel
//
//  Created by Jim Campagno on 12/4/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

protocol AvengerDetailDelegate: class {
    func canDisplayImage(sender: MarvelSeries?) -> Bool
}

class AvengerDetailView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var seriesImageView: UIImageView!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var seriesDescripLabel: UILabel!
    
    weak var delegate: AvengerDetailDelegate?
    let duration: TimeInterval = 0.8

    
    var avengerSeries: MarvelSeries! {
        didSet {
            setupTitleLabel()
            setupSeriesImage()
            setupSeriesDescrip()
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
        Bundle.main.loadNibNamed("AvengerDetailView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        backgroundColor = UIColor.clear
    }

}

// MARK: - Marvel Character Methods
extension AvengerDetailView {
    
    func setupTitleLabel() {
        updateTitleLabel(animated: avengerSeries.image == nil)
    }
    
    
    func setupSeriesImage() {
        guard avengerSeries.image == nil else { updateSeriesImage(animated: false); return }
        
        guard !avengerSeries.isDownloadingImage else { return }
        
        if !avengerSeries.canDownloadImage {
            avengerSeries.setNoImage()
            updateSeriesImage(animated: true)
            return
        }
        
        avengerSeries.downloadImage { [weak self] success in
            guard success, let theDelegate = self?.delegate else { return }
            if theDelegate.canDisplayImage(sender: self?.avengerSeries) {
                self?.updateSeriesImage(animated: true)
            }
        }
    }
    
    func setupSeriesDescrip() {
        updateSeriesDescrip(animated: avengerSeries.image == nil)
    }
    
    func updateTitleLabel(animated: Bool = false) {
        seriesTitleLabel.alpha = 0.0
        seriesTitleLabel.text = avengerSeries.title
        guard animated else { seriesTitleLabel.alpha = 1.0; return }
        UIView.animate(withDuration: duration, animations: {
            self.seriesTitleLabel.alpha = 1.0
        })
    }
    
    func updateSeriesImage(animated: Bool = false) {
        seriesImageView.alpha = 0.0
        seriesImageView.image = self.avengerSeries.image
        guard animated else { seriesImageView.alpha = 1.0; return }
        UIView.animate(withDuration: duration, animations: {
            self.seriesImageView.alpha = 1.0
        })
    }
    
    func updateSeriesDescrip(animated: Bool = false) {
        seriesDescripLabel.alpha = 0.0
        seriesDescripLabel.text = avengerSeries.seriesDescription
        guard animated else { seriesDescripLabel.alpha = 1.0; return }
        UIView.animate(withDuration: duration, animations: {
            self.seriesDescripLabel.alpha = 1.0
        })
    }
    

    
}

// MARK: - Helper Methods
extension AvengerDetailView {
    
    func clearPriorSeries() {
        alphaZeroAllViews()
        seriesImageView.image = nil
        seriesTitleLabel.text = nil
        seriesDescripLabel.text = nil
    }
    
    func alphaZeroAllViews() {
        seriesImageView.alpha = 0.0
        seriesTitleLabel.alpha = 0.0
        seriesDescripLabel.alpha = 0.0
    }
    
}
