//
//  AvengerSeriesView.swift
//  Marvel
//
//  Created by Jim Campagno on 12/4/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit
import RealmSwift

class AvengerSeriesView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var marvelSeries: LinkingObjects<MarvelSeries>!
    
    lazy var viewModel: MarvelSeriesDetailViewModel = {
        return MarvelSeriesDetailViewModel(marvelSeries: self.marvelSeries)
    }()
    
    let reuseIdentifier = "AvengerDetailCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AvengerSeriesView", owner: self, options: nil)
        tableView.register(AvengerDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupTableView()
        
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
}

// MARK: - UITableView Delegate
extension AvengerSeriesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let avengerCell = cell as! AvengerDetailTableViewCell
        avengerCell.avengerSeries = viewModel.series(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForCell
    }
    
    
    
}


// MARK: - UITableView Data Source
extension AvengerSeriesView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? AvengerDetailTableViewCell
        
        if cell == nil {
            
            cell = AvengerDetailTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.isUserInteractionEnabled = false
        }
        
        
        if cell?.avengerDetailView.delegate == nil { cell?.avengerDetailView.delegate = self }
        
        
        
        return cell!
    }
    
}

// MARK: - AvengerDetailViewDelegate
extension AvengerSeriesView: AvengerDetailDelegate {

    func canDisplayImage(sender: MarvelSeries?) -> Bool {
        guard let theSender = sender else { return false }
        viewModel.visibleIndexPaths = tableView?.indexPathsForVisibleRows ?? []
        return viewModel.seriesIsViewable(marvelSeries: theSender)
    }

}
