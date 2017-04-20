//
//  PhotoLayout.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

class PhotoLayout: UICollectionViewFlowLayout {
    
    var highlightHeight: CGFloat = 200
    var rowHeight: CGFloat = 100
    
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
        let newRect = rect.union(CGRect(x: 0, y: -rowHeight, width: 0, height: 0))
        let attributes = super.layoutAttributesForElements(in: newRect) ?? []
        for (i, attr) in attributes.enumerated() {
            attr.zIndex = i
            let f = self.collectionView!.convert(attr.frame, to: keyWindow)
            if f.origin.y > 0 && f.origin.y < highlightHeight && i != 0 {
                attr.frame.size.height += highlightHeight - f.origin.y
                attr.frame.origin.y -= highlightHeight - f.origin.y
            }
            if i == 0 && attr.frame.origin.y == rowHeight {
                attr.frame.size.height = highlightHeight
                attr.frame.origin.y = 0
            }
        }
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rect = CGRect(origin: proposedContentOffset, size: collectionView!.frame.size)
//        let attributes = layoutAttributesForElements(in: rect)
//        let attr = attributes!.first!
//        let c = self.collectionView!.convert(attr.center, to: keyWindow)
//        if c.x > 100 {
//            rect.origin.x += screenWidth / 2 - c.x
//        } else if c.x < 0 {
//            rect.origin.x += c.x - 10
//        }
        return rect.origin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
