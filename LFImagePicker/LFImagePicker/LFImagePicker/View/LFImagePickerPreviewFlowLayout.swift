//
//  LFImagePickerPreviewFlowLayout.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/31.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFImagePickerFlowLayout: UICollectionViewFlowLayout {

    var space:CGFloat!
    var itemOfRow:Int = 4
    
    override func prepare() {
        
        let bounds = UIScreen.main.compatibleBounds
        self.space = bounds.width  / CGFloat(itemOfRow) / 20.0
        self.minimumLineSpacing = space
        self.minimumInteritemSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(space, space, space, space)
        let width = ( bounds.width - self.space * 5 - 1) / CGFloat(itemOfRow)
        self.itemSize = CGSize(width: width, height: width)
//        if let collectionView = (self.collectionView as? LFImagePickerCollectionView) {
//            collectionView.contentOffset = self.targetContentOffset(forProposedContentOffset: collectionView.contentOffset)
//        }
    }
    // 旋转之后重新布局，维持contentOffset和之前显示的cell一致
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let collectionView = self.collectionView as? LFImagePickerCollectionView,let prevItemSize = collectionView.prevItemSize {
            let rows = collectionView.prevOffset / prevItemSize.width
            collectionView.prevItemSize = nil
            return CGPoint(x: 0, y: self.itemSize.width * rows)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
