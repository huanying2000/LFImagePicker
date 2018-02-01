//
//  ImagePickerPreviewCell.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/2/1.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class ImagePickerPreviewCell: UICollectionViewCell,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView:UIImageView = UIImageView()
    
    weak var controller:LFImagePickerPreviewController?
    
    fileprivate var model:LFImagePickerModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.zoomScale = 1
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.contentSize = CGSize.zero
        scrollView.delegate = self
        
        imageView.isUserInteractionEnabled = true
        self.scrollView.addSubview(imageView)
        
        //支持全屏放大 双击放大
        let singTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePickerPreviewCell.onImageSingleTap(_:)))
        singTapGesture.numberOfTapsRequired = 1
        singTapGesture.numberOfTouchesRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePickerPreviewCell.onImageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        singTapGesture.require(toFail: doubleTapGesture)
        self.addGestureRecognizer(singTapGesture)
        self.addGestureRecognizer(doubleTapGesture)
        
    }
    
    //当cell被重用之前调用
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
        scrollView.contentSize = CGSize.zero
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.zoomScale = 1.0
        scrollView.contentSize = CGSize.zero
        if let _image = imageView.image {
            let bounds = UIScreen.main.compatibleBounds
            let boundsDept = bounds.width / bounds.height
            let imgDept = _image.size.width / _image.size.height
            // 图片长宽和屏幕的宽高进行比较 设定基准边
            if imgDept > boundsDept {
                imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width / imgDept)
            } else {
                imageView.frame = CGRect(x: 0, y: 0, width: bounds.height * imgDept, height: bounds.height)
            }
            self.scrollView.layoutIfNeeded()
            self.scrollView.frame.origin = CGPoint.zero
            imageView.center = scrollView.center
        }
    }
    
    func initWithModel(_ model:LFImagePickerModel,controller:LFImagePickerPreviewController) {
        self.model = model
        self.controller = controller
        self.imageView.image = model.getPreviewImage()
        self.layoutSubviews()
    }
    
    //单击手势
    @objc func onImageSingleTap(_ sender:UITapGestureRecognizer) {
        if let controller = self.controller {
            controller.topView.isHidden = !controller.topView.isHidden
            controller.bottomView.isHidden = !controller.bottomView.isHidden
        }
    }
    
    //双击手势
    @objc func onImageDoubleTap(_ sender:UITapGestureRecognizer) {
        let zoomScale = scrollView.zoomScale
        if zoomScale <= 1.0 {
            let loc = sender.location(in: sender.view) as CGPoint
            let wh:CGFloat = 1
            let x:CGFloat = loc.x - 0.5
            let y:CGFloat = loc.y - 0.5
            let rect = CGRect(x: x, y: y, width: wh, height: wh)
            scrollView.zoom(to: rect, animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    func didEndScroll() {
        self.model.getImageAsync(){
            image in
            self.imageView.image = image
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var xcenter = scrollView.center.x
        var ycenter = scrollView.center.y
        
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter
        
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter
        imageView.center = CGPoint(x: xcenter, y: ycenter)
    }

}
