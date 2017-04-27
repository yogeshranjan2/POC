//
//  DeviceTableViewCell.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 01/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    //MARK:Properties
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceRatingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
