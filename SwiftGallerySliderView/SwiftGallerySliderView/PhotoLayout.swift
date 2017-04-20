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
//        print("---attr---")
        for (i, attr) in attributes.enumerated() {
            attr.zIndex = i
            let f = self.collectionView!.convert(attr.frame, to: keyWindow)
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
//            print("\(f) - \(attr.frame)")
        }
//        print("---")
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var newOffset = proposedContentOffset
        let rect = CGRect(x: 0, y: -rowHeight*2, width: screenWidth, height: collectionView!.contentSize.height)
        let attributes = layoutAttributesForElements(in: rect) ?? []
//        print("---offset---")
        for attr in attributes {
            let f = self.collectionView!.convert(attr.frame, to: keyWindow)
            let autualY = f.origin.y
            let absY = abs(f.origin.y)
            if autualY < 0 && absY < rowHeight / 2 {
//                print("autualY:\(autualY), \(f)")
                newOffset.y -= absY
                break
            }
            if autualY < 0 && absY > rowHeight / 2 && absY < rowHeight {
//                print("autualY:\(autualY), \(f)")
                newOffset.y += rowHeight - absY
                break
            }
        }
//        print("---")
        return newOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
