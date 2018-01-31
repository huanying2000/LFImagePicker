//
//  LFImagePickerCell.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/31.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFImagePickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var videoDuration: UILabel!
    
    var indexPath:IndexPath!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
