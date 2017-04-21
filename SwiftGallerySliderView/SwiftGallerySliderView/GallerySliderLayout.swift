//
//  GallerySliderLayout.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

class GallerySliderLayout: UICollectionViewFlowLayout {
    
    /// 放大的最大高度
    var highlightHeight: CGFloat = 200
    
    /// 正常的高度
    var normalHeight: CGFloat = 100
    
    // 基准视图，跟collectionView的frame相同的视图，用来计算第一片的相对屏幕位置
    private let baseFrameView: UIView
    
    private override init() {
        baseFrameView = UIView(frame: CGRect.zero)
        super.init()
    }
    
    convenience init(collectionFrame: CGRect) {
        self.init()
        self.itemSize = CGSize(width: screenWidth, height: normalHeight)
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = .vertical
        baseFrameView.frame = collectionFrame
        self.sectionInset = UIEdgeInsets(top: normalHeight, left: 0, bottom: collectionFrame.height-highlightHeight, right: 0)
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let `collectionView` = self.collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        // 获取所有attributes，如果不是所有，剩下的就不会显示，不知道为什么...
        let newRect = rect.union(CGRect(x: 0, y: -normalHeight, width: 0, height: 0))
        let attributes = super.layoutAttributesForElements(in: newRect) ?? []

        for (i, attr) in attributes.enumerated() {
            // 设置层次，让下面的比上面的大，挡住上面的
            attr.zIndex = i
            // 相对于基准视图的位置
            let f = collectionView.convert(attr.frame, to: baseFrameView)
            // 顶部上面被遮挡了的，都变回正常高度
            if f.origin.y < 0 {
                attr.frame.size.height = normalHeight
            }
            // 刚好在变化当中的两个片，改变高度的同时，调整y值
            if f.origin.y > 0 && f.origin.y < highlightHeight && i != 0 {
                attr.frame.size.height += highlightHeight - f.origin.y
                attr.frame.origin.y -= highlightHeight - f.origin.y
            }
            // 固定第一行
            if i == 0 && f.origin.y > 0 && attr.frame.origin.y == normalHeight {
                attr.frame.size.height = highlightHeight
                attr.frame.origin.y = 0
            }
            // 最大高度只能是设定值highlightHeight
            attr.frame.size.height = min(attr.frame.size.height, highlightHeight)
        }

        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let `collectionView` = self.collectionView else {
            return proposedContentOffset
        }
        
        var newOffset = proposedContentOffset
        let rect = CGRect(x: 0, y: -normalHeight*2, width: screenWidth, height: collectionView.contentSize.height)
        let attributes = layoutAttributesForElements(in: rect) ?? []
        
        // 加速度为0，简单判断最接近顶部的第一片的位置即可
        if velocity.y == 0 {
            for attr in attributes {
                let f = collectionView.convert(attr.frame, to: baseFrameView)
                let autualY = f.origin.y
                let absY = abs(f.origin.y)
                
                // 滑不到一半，则返回原位，滑了多少减回来多少
                if autualY < 0 && absY < normalHeight / 2 {
                    newOffset.y -= absY
                    break
                }
                
                // 超过一半，则翻一片，剩下多少就加多少
                if autualY < 0 && absY > normalHeight / 2 && absY <= normalHeight {
                    newOffset.y += normalHeight - absY
                    break
                }
            }
        }
        
        // 加速度不为0
        if velocity.y != 0 {
            // 往下，至少往下翻一片
            if velocity.y > 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(normalHeight) + 1) * normalHeight
            }
            // 往上，如果只是轻微滑一下下，则往上翻一片
            if velocity.y < 0 && abs(velocity.y) < 1 && newOffset.y != 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(normalHeight)) * normalHeight
            }
            // 往上，其他的计算翻多少片
            if velocity.y < 0 && abs(velocity.y) > 1 && newOffset.y != 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(normalHeight) - 1) * normalHeight
            }
        }
        
        collectionView.decelerationRate = 0.8
        return newOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
