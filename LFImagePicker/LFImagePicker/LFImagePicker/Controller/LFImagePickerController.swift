//
//  LFImagePickerController.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit



@objc protocol LFImagePickerControllerDelegate:NSObjectProtocol {
    // Implement it when setting source to LFImagePickerSource.ALAsset
    @objc optional func imagePickerController(picker:LFImagePickerController, didFinishPickingWithAssetsModels models:[LFImagePickerAssetsModel])
    
    // Implement it when setting source to LFImagePickerSource.Photos
    @available(iOS 8.0, *)
    @objc optional func imagePickerController(picker:LFImagePickerController, didFinishPickingWithPhotosModels models:[LFImagePickerPhotosModel])
    
    @objc optional func imagePickerControllerDidCancel(picker: LFImagePickerController)
}

protocol LFImagePickerDataSourceDelegate:NSObjectProtocol {
    var selectedSource:[LFImagePickerModel] { get set }
    var maxCount:Int { get }
    var mediaTypes:[LFImagePickerMediaType] { get }
    var source:LFImagePickerSource { get }
    func didFinishPicking()
    func didCancel()
}


class LFImagePickerController: UINavigationController,LFImagePickerDataSourceDelegate {
    public weak var imagePickerDelegate:LFImagePickerControllerDelegate?
    public var mediaTypes:[LFImagePickerMediaType]  = [.Photo]
    public var maxCount: Int = Int.max
    public var defaultShowCameraRoll:Bool = true
    public var selectedSource = [LFImagePickerModel]()
    private var _source = LFImagePickerSource.ALAsset
    public var source:LFImagePickerSource {
        get {
            return self._source
        }
        set {
            self._source = newValue
            // 只有iOS8以上才能使用Photos框架
            if newValue == .Photos {
                if #available(iOS 8.0, *) {
                    
                } else {
                    self._source = .ALAsset
                }
            }
        }
    }
    
    public var mediaTypesNSArray:NSArray {
        get {
            let arr = NSMutableArray()
            for mediaType in self.mediaTypes {
                arr.add(mediaType.rawValue)
            }
            return arr
        }
        set {
            self.mediaTypes.removeAll()
            for mediaType in newValue {
                if let intType = mediaType as? Int {
                    if intType == 0 {
                        self.mediaTypes.append(.Photo)
                    } else if intType == 1 {
                        self.mediaTypes.append(.Video)
                    }
                }
            }
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        if self.defaultShowCameraRoll {
            let controller = LFImagePickerAssetsController()
            controller.delegate = self
            LFImagePickerDataSource.fetchDefault(type: self.source, mediaTypes: self.mediaTypes) {
                controller.groupModel = $0
                self.pushViewController(controller, animated: false)
            }
        }
    }
    
    class var instance:LFImagePickerController {
        get {
            let controller = LFImagePickerAlbumsController()
            let navigation = LFImagePickerController(rootViewController: controller)
            controller.delegate = navigation
            return navigation
        }
    }
    
    
    func didFinishPicking() {
        if self.source == .Photos {
            if #available(iOS 8.0, *) {
                self.imagePickerDelegate?.imagePickerController?(picker:self, didFinishPickingWithPhotosModels: selectedSource as! [LFImagePickerPhotosModel])
            } else {
                // Fallback on earlier versions
            }
        } else {
            self.imagePickerDelegate?.imagePickerController?(picker:self, didFinishPickingWithAssetsModels: selectedSource as! [LFImagePickerAssetsModel])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func didCancel() {
        imagePickerDelegate?.imagePickerControllerDidCancel?(picker: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}



