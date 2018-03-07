//
//  AttractionTableViewCell.swift
//  TableViewStory
//
//  Created by Mohd Farhan Khan on 3/7/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: CustomImageView!
    var onCheckTapped : (() -> Void)? = nil
    var onNextTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func saveCell(_ sender: Any) {
        if let image = UIImage(named: "check") {
            checkButton.setImage(image, for: .normal)
        }
        if let onCheckTapped = self.onCheckTapped {
            onCheckTapped()
        }
    }
    @IBAction func goToNext(_ sender: Any) {
        if let onNextTapped = self.onNextTapped {
            onNextTapped()
        }
    }
   

}
