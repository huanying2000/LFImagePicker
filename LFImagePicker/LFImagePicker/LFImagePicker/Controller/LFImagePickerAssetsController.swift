//
//  LFImagePickerAssetsController.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/31.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFImagePickerAssetsController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: LFImagePickerCollectionView!
    weak var delegate:LFImagePickerDataSourceDelegate!
    var groupModel:LFImagePickerAlbumModel!
    
    private var dataSource = [LFImagePickerModel]();
    private var initialScrollDone:Bool = false
    //用户选中数量
    @IBOutlet weak var selectedCountLbl: UILabel!
    //预览Btn
    @IBOutlet weak var preViewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = self.groupModel.getAlbumName() {
            self.title = title
        }
        self.collectionView.register(UINib(nibName: "LFImagePickerCell", bundle: nil), forCellWithReuseIdentifier: "LFImageCollectionViewCell")
        self.selectedCountLbl.layer.masksToBounds = true
        self.selectedCountLbl.layer.cornerRadius = 10.0
        let loading = LoadingViewController()
        loading.show(text: "Loading..".localized)
        self.groupModel.getLFImagePickerModelsListAsync { (models) in
            loading.dismiss()
            self.dataSource = models
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.selectedCountLbl.text = String(delegate.selectedSource.count)
        self.preViewBtn.isEnabled = !(delegate.selectedSource.count == 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.initialScrollDone {
            self.initialScrollDone = true
            self.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        if self.dataSource.count > 0 {
            let indexPath = IndexPath(item: self.dataSource.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LFImageCollectionViewCell", for: indexPath) as? LFImagePickerCell
        let model = self.dataSource[indexPath.item]
        if model.mediaType == .Video {
            cell?.videoView.isHidden = false
            model.getVideoDurationAsync(complete: { (duration) in
                DispatchQueue.main.async {
                    cell?.videoDuration.text = duration.timeFormat()
                }
            })
        }else {
            cell?.videoView.isHidden = true
        }
        
        cell?.imageView.image = model.getThumbImage(size: (cell?.imageView.frame.size)!)
        cell?.indexPath = indexPath
        cell?.btnCheck.isSelected = delegate.selectedSource.contains(model)
        cell?.btnCheck.addTarget(self, action: #selector(LFImagePickerAssetsController.btnCheckTouch(_:)), for: .touchUpInside)
        return cell!
    }
    //MARK: 点击图片 预览
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func btnCheckTouch(_ sender:UIButton) {
        if delegate.selectedSource.count < delegate.maxCount || sender.isSelected == true {
                sender.isSelected = !sender.isSelected
            let index = (sender.superview?.superview as! LFImagePickerCell).indexPath.item
            if sender.isSelected {
                delegate.selectedSource.append(self.dataSource[index])
                sender.heartbeatsAnimation(duration: 0.15)
            }else {
                if let removeIndex = delegate.selectedSource.index(of: self.dataSource[index]) {
                    delegate.selectedSource.remove(at: removeIndex)
                }
            }
            self.selectedCountLbl.text = String(delegate.selectedSource.count)
            self.selectedCountLbl.heartbeatsAnimation(duration: 0.15)
            self.preViewBtn.isEnabled = !(delegate.selectedSource.count == 0)
        }else {
            let alertView = FlashAlertView(message: "Maxium selected".localized, delegate: nil)
            alertView.show()
        }
    }
    
    //MARK：旋转处理
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if self.interfaceOrientation.isPortrait != toInterfaceOrientation.isPortrait {
            self.collectionView.prevItemSize = (self.collectionView.collectionViewLayout as! LFImagePickerFlowLayout).itemSize
            self.collectionView.prevOffset = self.collectionView.contentOffset.y
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    //用户点击完成
    @IBAction func btnFinishedComplete(_ sender: Any) {
        
    }
    
    //预览
    @IBAction func btnPreviewTouch(_ sender: Any) {
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}


class LFImagePickerCollectionView: UICollectionView {
    
    var prevItemSize:CGSize?
    var prevOffset:CGFloat = 0
}















