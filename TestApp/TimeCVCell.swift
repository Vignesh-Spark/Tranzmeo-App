//
//  TimeCVCell.swift
//  TestApp
//
//  Created by VIGNESH on 16/12/21.
//

import UIKit

class TimeCVCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var backView : UIView!
    
    
    override func awakeFromNib() {
        
        self.setStyle()
        
    }
    
    func setStyle()  {
        
        self.timeLabel.textColor = .blue
        self.backView.layer.borderWidth = 1
        self.backView.layer.borderColor = UIColor.blue.cgColor
        self.backView.layer.cornerRadius = 5
        self.backView.layer.masksToBounds = true
    }

    
}
