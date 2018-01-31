//
//  LFImagePickerAssetsModel.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation

public class LFImagePickerAssetsModel: LFImagePickerModel {
    public var asset:ALAsset!
    var lib:ALAssetsLibrary = ALAsset.lib
    
    private lazy var rept:ALAssetRepresentation = {
        return self.asset.defaultRepresentation()
    }()
    init(mediaType: LFImagePickerMediaType,asset:ALAsset) {
        super.init(mediaType: mediaType)
        self.asset = asset
    }
    
    override func getFileName() -> String? {
        return self.rept.filename()
    }
    
    override func getThumbImage(size: CGSize) -> UIImage? {
        return UIImage(cgImage: self.asset.thumbnail().takeUnretainedValue())
    }
    
    override func getPreviewImage() -> UIImage? {
        return UIImage(cgImage: self.asset.aspectRatioThumbnail().takeUnretainedValue())
    }
    
    override func getImageAsync(complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = UIImage(cgImage: self.rept.fullScreenImage().takeUnretainedValue())
            DispatchQueue.main.async {
                complete(image)
            }
        }
    }
    
    override func getVideoDurationAsync(complete: @escaping (Double) -> Void) {
        complete((self.asset.value(forProperty: ALAssetPropertyDuration) as AnyObject).doubleValue)
    }
    
    
    override func getAVPlayerItem() -> AVPlayerItem? {
        return AVPlayerItem(url: self.rept.url())
    }
    
    override func getFileSize() -> Int {
        return Int(self.rept.size())
    }
    
    override func getIdentity() -> String {
        return self.rept.url().absoluteString
    }
    
}

class LFImagePickerAssetsAlbumModel:LFImagePickerAlbumModel {
    private var group:ALAssetsGroup
    
    init(group:ALAssetsGroup) {
        self.group = group
    }
    
    override func getAlbumCount() -> Int {
        return self.group.numberOfAssets()
    }
    
    override func getAlbumName() -> String? {
        return self.group.value(forProperty: ALAssetsGroupPropertyName) as? String
    }
    override func getAlbumImage(size:CGSize) -> UIImage? {
        return UIImage(cgImage: self.group.posterImage().takeUnretainedValue())
    }
    
    override func getLFImagePickerModelsListAsync(complete: @escaping ([LFImagePickerModel]) -> ()) {
        var models = [LFImagePickerModel]()
        DispatchQueue.global().async {
            self.group.enumerateAssets({ (result, index, success) in
                if let asset = result {
                    let ALAssetType = result?.value(forProperty: ALAssetPropertyType) as! NSString
                    let mediaType:LFImagePickerMediaType = ALAssetType.isEqual(to: ALAssetTypePhoto) ? .Photo : .Video
                    let model = LFImagePickerAssetsModel(mediaType: mediaType, asset:asset)
                    models.append(model)
                }
            })
            DispatchQueue.main.async {
                complete(models)
            }
        }
    }
    
}

















