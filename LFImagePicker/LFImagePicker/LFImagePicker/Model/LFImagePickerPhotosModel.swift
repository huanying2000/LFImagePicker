//
//  LFImagePickerPhotosModel.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit
import Photos

@available(iOS 8.0,*)
public class LFImagePickerPhotosModel: LFImagePickerModel {
    public var phasset:PHAsset!
    init(mediaType: LFImagePickerMediaType,phasset:PHAsset) {
        super.init(mediaType: mediaType)
        self.phasset = phasset
    }
    
    override func getFileName() -> String? {
        var fileName:String?
        self.fetchDataSync { (data, dataUTI, orientation, infoDict) in
            if let name = (infoDict?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent {
                fileName = name
            }
        }
        return fileName
    }
    
    override func getThumbImage(size: CGSize) -> UIImage? {
        var img:UIImage?
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: self.phasset, targetSize: size, contentMode: .aspectFill, options: options) { (image, infoDict) in
            img = image
        }
        return img
    }
    
    
    override func getPreviewImage() -> UIImage? {
        var img:UIImage?
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        var size = UIScreen.main.compatibleBounds.size
        size = CGSize(width: size.width / 3.0, height: size.height / 3.0)
        PHImageManager.default().requestImage(for: self.phasset, targetSize: size, contentMode: .aspectFit, options: options) { (image, infoDict) in
            img = image
        }
        return img
    }
    
    override func getImageAsync(complete: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: self.phasset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) {
            image,infoDict in
            complete(image)
        }
    }
    
    override func getVideoDurationAsync(complete: @escaping (Double) -> Void) {
        PHImageManager.default().requestAVAsset(forVideo: self.phasset, options: nil) { (avasset, _, _) in
            if let asset = avasset {
                let duration = Double(asset.duration.value) / Double(asset.duration.timescale)
                complete(duration)
            }
         }
    }
    
    override func getAVPlayerItem() -> AVPlayerItem? {
        return self.fetchAVPlayerItemSync()
    }
    
    
    override func getFileSize() -> Int {
         var fileSize = 0
        self.fetchDataSync { (data, dataUTI, orientation, infoDict) in
            if let d = data {
                fileSize = d.length
            }
        }
        return fileSize
    }
    
    override func getIdentity() -> String {
        return self.phasset.localIdentifier
    }
    
    
    private func fetchAVPlayerItemSync() ->AVPlayerItem? {
        var playerItem:AVPlayerItem?
        let sem = DispatchSemaphore(value: 0)
        PHImageManager.default().requestPlayerItem(forVideo: self.phasset, options: nil){
            item,infoDict in
            playerItem = item
            sem.signal()
        }
        sem.wait()
        return playerItem
    }
    
    /*UIImageOrientation 图片的方向属性*/
    /**
     请求图像
     
     图像请求是通过 requestImageForAsset(...) 方法派发的。这个方法接受一个 PHAsset，可以设置返回图像的大小和图像的其它可选项 (通过 PHImageRequestOptions 参数对象设置)，以及结果回调 (result handler)。这个方法的返回值可以用来在所请求的数据不再被需要时取消这个请求。
     图像的尺寸和裁剪
     
     奇怪的是，对返回图像的尺寸定义和裁剪的参数是分布在两个地方的。targetSize 和 contentMode 这俩参数会被直接传入 requestImageForAsset(...) 方法内。这个 content Mode 和 UIView 的 contentMode 参数类似，决定了照片应该以按比例缩放还是按比例填充的方式放到目标大小内。注意：如果不对照片大小进行修改或裁剪，那么方法参数是 PHImageManagerMaximumSize 和 PHImageContentMode.Default 。
     
     此外，PHImageRequestOptions 还提供了一些方式来确定图像管理器该以怎样的方式来重新设置图像大小。resizeMode 属性可以设置为 .Exact (返回图像必须和目标大小相匹配)，.Fast (比 .Exact 效率更高，但返回图像可能和目标大小不一样) 或者 .None。还有个值得一提的是，normalizedCroppingMode 属性让我们确定图像管理器应该如何裁剪图像。注意：如果设置了 normalizedcroppingMode 的值，那么 resizeMode 需要设置为 .Exact。
     请求递送和进度
     
     默认情况下，如果图像管理器决定要用最优策略，那么它会在将图像的高质量版本递送给你之前，先传递一个较低质量的版本。你可以通过 deliveryMode 属性来控制这个行为；上面所描述的默认行为的值为 .Opportunistic。如果你只想要高质量的图像，并且可以接受更长的加载时间，那么将属性设置为 .HighQualityFormat。如果你想要更快的加载速度，且可以牺牲一点图像质量，那么将属性设置为 .FastFormat。
     
     你可以使用 PHImageRequestOptions 的 synchronous 属性，让 requestImage... 系列的方法变成同步操作。注意：当 synchronous 设为 true 时，deliveryMode 属性就会被忽略，并被当作 .HighQualityFormat 来处理。
     
     在设置这些参数时，一定要考虑到你的一些用户有可能开启了 iCloud 照片库，这点非常重要。PhotoKit 的 API 不一定会对设备的照片和 iCloud 上照片进行区分 —— 它们都用同一个 requestImage 方法来加载。这意味着任意一个图像请求都有可能是一个通过蜂窝网络来进行的非常缓慢的网络请求。当你要用 .HighQualityFormat 或者做一个同步请求的时候，要牢记这个。注意：如果你想要确保请求不经过网络，可以将 networkAccessAllowed 设为 false 。
     
     另一个和 iCloud 相关的属性是 progressHandler。你可以将它设为一个 PHAssetImageProgressHandler 的 block，当从 iCloud 下载照片时，它就会被图像管理器自动调用。
     */
    private func fetchDataSync(complete:@escaping(NSData?,String?,UIImageOrientation,[AnyHashable:Any]?)->()) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImageData(for: self.phasset, options: requestOptions) { (data, dataUTI, oriebtation, infoDict) in
            complete(data as NSData?,dataUTI,oriebtation,infoDict)
        }
    }
}

@available(iOS 8.0,*)
class LFImagePickerPhotosAlbumModel:LFImagePickerAlbumModel {
    private var result:PHFetchResult<AnyObject>
    private var _albumCount:Int
    private var _albumName:String?
    
    init(result:PHFetchResult<AnyObject>,albumCount:Int,albumName:String?) {
        self.result = result
        self._albumName = albumName
        self._albumCount = albumCount
    }
    
    override func getAlbumImage(size: CGSize) -> UIImage? {
        if let asset = self.result.object(at: 0) as? PHAsset {
            let model = LFImagePickerPhotosModel(mediaType: .Photo, phasset: asset)
            return model.getThumbImage(size: size)
        }
        return nil
    }
    
    override func getAlbumCount() -> Int {
        return self._albumCount
    }
    
    override func getAlbumName() -> String? {
        return self._albumName
    }
    
    override func getLFImagePickerModelsListAsync(complete: @escaping ([LFImagePickerModel]) -> ()) {
        var models = [LFImagePickerModel]();
        DispatchQueue.global(qos: .default).async {
            self.result.enumerateObjects({ (asset, index, isStop) in
                if let phasset = asset as? PHAsset {
                    let mediaType:LFImagePickerMediaType = phasset.mediaType == .image ? .Photo : .Video
                    let model = LFImagePickerPhotosModel(mediaType: mediaType, phasset: phasset)
                    models.append(model)
                }
            })
            DispatchQueue.main.async {
                complete(models)
            }
        }
    }
    
    
}

















