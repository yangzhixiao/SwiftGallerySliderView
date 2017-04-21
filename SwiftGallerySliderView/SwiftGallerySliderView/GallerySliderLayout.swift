//
//  GallerySliderLayout.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

class GallerySliderLayout: UICollectionViewFlowLayout {
    
    var highlightHeight: CGFloat = 200
    var rowHeight: CGFloat = 100
    
    private let baseFrameView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: screenWidth, height: rowHeight)
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: rowHeight, left: 0, bottom: screenHeight-highlightHeight, right: 0)
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
        let newRect = rect.union(CGRect(x: 0, y: -rowHeight, width: 0, height: 0))
        let attributes = super.layoutAttributesForElements(in: newRect) ?? []

        for (i, attr) in attributes.enumerated() {
            // 设置层次，让下面的比上面的大，挡住上面的
            attr.zIndex = i
            let f = collectionView.convert(attr.frame, to: baseFrameView)
            if f.origin.y < 0 {
                attr.frame.size.height = rowHeight
            }
            if f.origin.y > 0 && f.origin.y < highlightHeight && i != 0 {
                attr.frame.size.height += highlightHeight - f.origin.y
                attr.frame.origin.y -= highlightHeight - f.origin.y
            }
            // 固定第一行
            if i == 0 && f.origin.y > 0 && attr.frame.origin.y == rowHeight {
                attr.frame.size.height = highlightHeight
                attr.frame.origin.y = 0
            }
            attr.frame.size.height = min(attr.frame.size.height, highlightHeight)
        }

        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let `collectionView` = self.collectionView else {
            return proposedContentOffset
        }
        
        var newOffset = proposedContentOffset
        let rect = CGRect(x: 0, y: -rowHeight*2, width: screenWidth, height: collectionView.contentSize.height)
        let attributes = layoutAttributesForElements(in: rect) ?? []
        
        // 加速度为0，简单判断最接近顶部的第一片的位置即可
        if velocity.y == 0 {
            for attr in attributes {
                let f = collectionView.convert(attr.frame, to: baseFrameView)
                let autualY = f.origin.y
                let absY = abs(f.origin.y)
                
                // 滑不到一半，则返回原位，滑了多少减回来多少
                if autualY < 0 && absY < rowHeight / 2 {
                    newOffset.y -= absY
                    break
                }
                
                // 超过一半，则翻一片，剩下多少就加多少
                if autualY < 0 && absY > rowHeight / 2 && absY <= rowHeight {
                    newOffset.y += rowHeight - absY
                    break
                }
            }
        }
        
        // 加速度不为0
        if velocity.y != 0 {
            // 往下，至少往下翻一片
            if velocity.y > 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(rowHeight) + 1) * rowHeight
            }
            // 往上，如果只是轻微滑一下下，则往上翻一片
            if velocity.y < 0 && abs(velocity.y) < 1 && newOffset.y != 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(rowHeight)) * rowHeight
            }
            // 往上，其他的计算翻多少片
            if velocity.y < 0 && abs(velocity.y) > 1 && newOffset.y != 0 {
                newOffset.y = CGFloat(Int(newOffset.y) / Int(rowHeight) - 1) * rowHeight
            }
        }
        
        return newOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
