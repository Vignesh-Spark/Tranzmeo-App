//
//  TimeSelectorCell.swift
//  TestApp
//
//  Created by VIGNESH on 17/12/21.
//

import UIKit

class TimeSelectorCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var dateDate : date!
    
    
    override func awakeFromNib() {

    }
    override func prepareForReuse() {
        
        self.bottomView.isHidden = true
        self.timeLabel.text = ""
    }
    func configure() {
        
        
        self.timeLabel.text = dateDate.dateValue
        if dateDate.isSelected {
            self.bottomView.isHidden = false
        }
        else{
            self.bottomView.isHidden = true
        }
    }
    
}
