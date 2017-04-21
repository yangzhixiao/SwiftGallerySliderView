//
//  GallerySliderCell.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

class GallerySliderCell: UICollectionViewCell {
    
    let titleLabel: UILabel
    
    let containerView: UIView
    
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        containerView.backgroundColor = UIColor.clear
        super.init(frame: frame)
        containerView.addSubview(titleLabel)
        addSubview(containerView)
    }
    
    func ajustCell(attr: UICollectionViewLayoutAttributes, frame: CGRect) {
        guard let `indexPath` = indexPath else {
            return
        }
        guard indexPath == attr.indexPath else {
            return
        }
//        containerView.frame.size.height = 100 + frame.origin.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
