//
//  ViewController.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit
import AssetsLibrary
class ViewController: UIViewController,LFImagePickerControllerDelegate {

    private var dataSource = [LFImagePickerModel]()
    private var lib:ALAssetsLibrary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var mediaTypes = [LFImagePickerMediaType]()
        let defaultShowCameraRoll = true
        mediaTypes.append(LFImagePickerMediaType.Photo)
//        mediaTypes.append(LFImagePickerMediaType.Video) //如果想加载视频的话
        let source = LFImagePickerSource.Photos //可以换成 ALAsset
        // 使用示例
        let vc = LFImagePickerController()
        vc.mediaTypes = mediaTypes
        vc.source = source
        vc.imagePickerDelegate = self
        
        vc.maxCount = 9
        
        vc.defaultShowCameraRoll = defaultShowCameraRoll
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @available(iOS 8.0, *)
    func imagePickerController(picker: LFImagePickerController, didFinishPickingWithPhotosModels models: [LFImagePickerPhotosModel]) {
        for model in models {
            model.getThumbImage(size: CGSize(width: 100, height: 100))
        }
        
    }
    
    //如果使用的是ALAsset
//    func imagePickerController(picker: LFImagePickerController, didFinishPickingWithAssetsModels models: [LFImagePickerAssetsModel]) {
//        self.dataSource = models
//
//    }
    
    func imagePickerControllerDidCancel(picker: LFImagePickerController) {
        print("cancel")
    }

}

