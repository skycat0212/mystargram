//
//  FeedCollectionViewCell.swift
//  mystargram
//
//  Created by Kim on 2021/06/17.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var feedImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

}
