//
//  GallerySliderCell.swift
//  SwiftGallerySliderView
//
//  Created by 杨智晓 on 2017/4/18.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

protocol GallerySliderCellDelegate: NSObjectProtocol {
    func switchNavigator(_ tag: Int)
}

class GallerySliderCell: UICollectionViewCell {
    var imageView: UIImageView!
    var cellMaskView: UIView!
    var title: UILabel!
    var desc: UILabel!
    var isHasLayout: Bool = false
    var currentBackURL: URL!
    var cellIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHasLayout = false
        clipsToBounds = true
        //根据当前CELL所在屏幕的不同位置，初始化IMAGEVIEW的相对位置，为了配合滚动时的IMAGEVIEW偏移动画
        //(screen_y-attributes.frame.origin.y)/568*80
        imageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(IMAGEVIEW_ORIGIN_Y - self.frame.origin.y / 568.0 * IMAGEVIEW_MOVE_DISTANCE), width: CGFloat(ScreenWidth), height: CGFloat(SC_IMAGEVIEW_HEIGHT)))
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        cellMaskView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(250)))
        cellMaskView.backgroundColor = UIColor.black
        cellMaskView.alpha = 0.6
        addSubview(cellMaskView)
        title = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat((CELL_HEIGHT - TITLE_HEIGHT) / 2), width: CGFloat(ScreenWidth), height: CGFloat(TITLE_HEIGHT)))
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: CGFloat(25))
        title.textAlignment = .center
        addSubview(title)
        contentMode = .center
        title.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        title.center = contentView.center
        title.backgroundColor = UIColor.clear
        desc = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat((CELL_HEIGHT - TITLE_HEIGHT) / 2 + 30), width: CGFloat(ScreenWidth), height: CGFloat(TITLE_HEIGHT)))
        desc.textColor = UIColor.white
        desc.font = UIFont.systemFont(ofSize: CGFloat(13))
        desc.textAlignment = .center
        addSubview(desc)
        contentMode = .center
        desc.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        desc.center = CGPoint(x: CGFloat(title.center.x), y: CGFloat(title.center.y + 15))
        desc.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func revisePositionAtFirstCell() {
        if tag == 1 {
            title.layer.transform = CATransform3DMakeScale(1, 1, 1)
            desc.alpha = 0.85
            title.center = CGPoint(x: CGFloat(UIScreen.main.bounds.size.width / 2), y: CGFloat(contentView.center.y))
            desc.frame = CGRect(x: CGFloat(10), y: CGFloat(title.center.y + 20), width: CGFloat(desc.frame.size.width), height: CGFloat(desc.frame.size.height))
            desc.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

    func setIndex(_ index: Int) {
        cellIndex = index
        if cellIndex == 0 {
            cellMaskView?.alpha = 0
            backgroundColor = UIColor.lightGray
        }
        else if cellIndex == 1 {
            cellMaskView?.alpha = 0.2
            backgroundColor = UIColor.black
        }
        else {
            cellMaskView?.alpha = 0.6
            backgroundColor = UIColor.black
        }
        
        setImageViewPostion()
    }
    
    func setImageViewPostion() {
        imageView?.frame = CGRect(x: CGFloat(0), y: CGFloat(IMAGEVIEW_ORIGIN_Y - frame.origin.y / 568 * IMAGEVIEW_MOVE_DISTANCE), width: CGFloat(ScreenWidth), height: CGFloat(SC_IMAGEVIEW_HEIGHT))
    }
    
    func setNameLabel(_ string: String) {
        let str = NSMutableAttributedString(string: string)
        title.attributedText = str
    }
    
    func setDescLabel(_ string: String?) {
        if string == nil || (string == "") {
            return
        }
        let str = NSMutableAttributedString(string: string!)
        desc.attributedText = str
        desc.frame = CGRect(x: CGFloat(10), y: CGFloat(desc.frame.origin.y), width: CGFloat(ScreenWidth - 20), height: CGFloat(30))
    }
    
    /**
     *  重置属性
     */
    func reset() {
        imageView?.image = nil
        title.text = ""
        desc.text = ""
    }
    
    deinit {
        imageView = nil
        cellMaskView = nil
        title = nil
    }
    
}
