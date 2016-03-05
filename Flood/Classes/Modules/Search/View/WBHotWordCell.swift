//
//  WBHotWordCell.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class WBHotWordCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data: WBHotWord) {
        indexLabel.text = "\(data.index)"
        titleLabel.text = data.title
        rankLabel.text = data.rank
        indexLabel.textColor = data.index < 4 ? UIColor(hex: 0xF56565) : UIColor.darkGrayColor()
    }
}
