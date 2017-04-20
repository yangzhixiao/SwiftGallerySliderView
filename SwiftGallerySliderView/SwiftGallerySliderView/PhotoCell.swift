//
//  PhotoCell.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let titleLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
