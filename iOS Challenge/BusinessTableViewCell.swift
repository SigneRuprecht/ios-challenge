//
//  BusinessTableViewCell.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(business: Business) {
        self.name.text = business.title
        
        oneStar.image = UIImage(named: "starEmpty")
        twoStar.image = UIImage(named: "starEmpty")
        threeStar.image = UIImage(named: "starEmpty")
        fourStar.image = UIImage(named: "starEmpty")
        fiveStar.image = UIImage(named: "starEmpty")
        
        switch(business.rating) {
        case 0:
            break
        case 0.5:
            oneStar.image = UIImage(named: "starHalf")
            break
        case 1:
            oneStar.image = UIImage(named: "starFull")
            break
        case 1.5:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starHalf")
            break
        case 2:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            break
        case 2.5:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starHalf")
            break
        case 3:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starFull")
            break
        case 3.5:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starFull")
            fourStar.image = UIImage(named: "starHalf")
            break
        case 4:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starFull")
            fourStar.image = UIImage(named: "starFull")
            break
        case 4.5:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starFull")
            fourStar.image = UIImage(named: "starFull")
            fiveStar.image = UIImage(named: "starHalf")
            break
        case 5:
            oneStar.image = UIImage(named: "starFull")
            twoStar.image = UIImage(named: "starFull")
            threeStar.image = UIImage(named: "starFull")
            fourStar.image = UIImage(named: "starFull")
            fiveStar.image = UIImage(named: "starFull")
            break
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
