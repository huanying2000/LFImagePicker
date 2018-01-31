//
//  LFImagePickerModel.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit
import AVFoundation


func == (lhs:LFImagePickerModel, rhs:LFImagePickerModel) -> Bool {
    return lhs.getIdentity() == rhs.getIdentity()
}


@objc public enum LFImagePickerMediaType:Int {
    case Photo
    case Video
}

public class LFImagePickerModel: NSObject {
    //实现自定义的array contains
    override public func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? LFImagePickerModel else {
            return false
        }
        return obj.getIdentity() == self.getIdentity()
    }
    
    public var mediaType:LFImagePickerMediaType
    
    init(mediaType:LFImagePickerMediaType) {
        self.mediaType = mediaType
    }
    func getIdentity() ->String {
        fatalError("getIdentity has not been implemented")
    }
    func getFileName() -> String? {
        fatalError("getFileName has not been implemented")
    }
    func getThumbImage(size:CGSize)-> UIImage? {
        fatalError("getThumbImage has not been implemented")
    }
    
    func getPreviewImage() -> UIImage?{
        fatalError("getPreviewImage has not been implemented")
    }
    
    func getImageAsync(complete: @escaping (UIImage?) -> Void) {
        fatalError("getImageAsync has not been implemented")
    }
    
    func getVideoDurationAsync(complete: @escaping (Double) -> Void) {
        fatalError("getVideoDurationAsync has not been implemented")
    }
    
    func getAVPlayerItem () -> AVPlayerItem? {
        fatalError("getAVPlayerItem has not been implemented")
    }
    
    func getFileSize() -> Int {
        fatalError("getFileSize has not been implemented")
    }
}


class LFImagePickerAlbumModel: NSObject {
    func getAlbumName() ->String? {
         fatalError("getAlbumName has not been implemented")
    }
    func getAlbumImage(size:CGSize) -> UIImage? {
        fatalError("getAlbumImage has not been implemented")
    }
    
    func getAlbumCount() -> Int {
        fatalError("getAlbumCount has not been implemented")
    }
    func getLFImagePickerModelsListAsync(complete: @escaping ([LFImagePickerModel])->()) {
        fatalError("getMTImagePickerModelsAsync has not been implemented")
    }
}














