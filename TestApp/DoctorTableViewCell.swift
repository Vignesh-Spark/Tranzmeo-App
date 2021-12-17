//
//  DoctorTableViewCell.swift
//  TestApp
//
//  Created by VIGNESH on 16/12/21.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder

class DoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var preofessionLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var constultButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setStyle()

    }
    override func prepareForReuse() {
        self.profileImageView?.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(data : doctorData) {
        
        nameLabel.text = (data.initials ?? "") + " " + (data.firstName ?? "") + " " + (data.lastName ?? "")
        preofessionLabel.text = data.descriptions
        experienceLabel.text = String(data.experience ?? 1) + " experience"
        
        if data.isQuikdr {
            self.websiteLabel.text = "QuikDr Healthcare"
        }
        else{
            self.websiteLabel.text = ""
        }
        
        if data.profilephotourl != nil {
            
            self.profileImageView.sd_setImage(with: URL(string: data.profilephotourl!),placeholderImage: UIImage(named: "ProfilePlaceHolder"))
        }
        self.setStyle()
        
    }
    
    func setStyle()  {       

        self.backView.layer.cornerRadius = 15
        self.backView.layer.masksToBounds = true
        
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.shadowRadius = 3
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = false
    }


    @IBAction func consultButtonAction(_ sender: Any) {
    }
}
