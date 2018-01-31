//
//  LFImagePickerAlbumCell.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFImagePickerAlbumCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var lbAlbumCount: UILabel!
    @IBOutlet weak var lbAlbumName: UILabel!
    
    
    func setup(model:LFImagePickerAlbumModel) {
        self.lbAlbumCount.text = "\(model.getAlbumCount())"
        self.lbAlbumName.text = model.getAlbumName()
        print("这个model是什么  \(model)")
        self.posterImageView.image = model.getAlbumImage(size: self.posterImageView.frame.size)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
