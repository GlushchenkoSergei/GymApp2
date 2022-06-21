//
//  DateViewCell.swift
//  GymApp2
//
//  Created by mac on 20.06.2022.
//

import UIKit

class DateViewCell: UICollectionViewCell {
    
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelDelete: UILabel!
    
    var isEditing = false {
        didSet {
            labelDelete.isHidden = !isEditing
        }
    }
}
