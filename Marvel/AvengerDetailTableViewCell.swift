//
//  AvengerDetailTableViewCell.swift
//  Marvel
//
//  Created by Jim Campagno on 12/4/16.
//  Copyright © 2016 Jim Campagno. All rights reserved.
//

import UIKit

class AvengerDetailTableViewCell: UITableViewCell {
    
    var avengerDetailView: AvengerDetailView!
    
    var avengerSeries: MarvelSeries! {
        didSet {
            avengerDetailView.avengerSeries = avengerSeries
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit() {
        avengerDetailView = AvengerDetailView(frame: contentView.bounds)
        avengerDetailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avengerDetailView)
        avengerDetailView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        avengerDetailView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        avengerDetailView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        avengerDetailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        isUserInteractionEnabled = false
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avengerDetailView.clearPriorSeries()
    }

}
