//
//  GallerySliderLayout.swift
//  SwiftGallerySliderView
//
//  Created by 杨智晓 on 2017/4/18.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

protocol GallerySliderLayoutDelegate: NSObjectProtocol {
    func setEffectOfHead(_ offsetY: CGFloat)
}

class GallerySliderLayout: UICollectionViewFlowLayout {
    weak var delegate: GallerySliderLayoutDelegate?
    var count: Int = 0
    
    override init() {
        super.init()
        
        itemSize = CGSize(width: CGFloat(ScreenWidth), height: CGFloat(CELL_HEIGHT))
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentSize(_ count: Int) {
        self.count = count
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes? = layoutAttributesForItem(at: itemIndexPath)
        return attr!
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(ScreenWidth), height: CGFloat(HEADER_HEIGHT + DRAG_INTERVAL * CGFloat(count) + (UIScreen.main.bounds.size.height - DRAG_INTERVAL)))
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let screen_y: CGFloat = collectionView!.contentOffset.y
        let current_floor: CGFloat = CGFloat(floorf(Float((screen_y - HEADER_HEIGHT) / DRAG_INTERVAL)) + 1)
        let current_mod: CGFloat = CGFloat(fmodf((Float(screen_y - HEADER_HEIGHT)), Float(DRAG_INTERVAL)))
        let percent: CGFloat = current_mod / DRAG_INTERVAL
        
        //计算当前应该显示在屏幕上的CELL在默认状态下应该处于的RECT范围，范围左右范围进行扩展，避免出现BUG
        //之前的方法采用所有ITEM进行布局计算，当ITEM太多后，会严重影响性能体验，所有采用这种方法
        var correctRect = CGRect.zero
        if current_floor == 0 || current_floor == 1 {
            //因为导航栏和当前CELL的高度特殊，所有做特殊处理
            correctRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(RECT_RANGE))
        }
        else {
            correctRect = CGRect(x: CGFloat(0), y: CGFloat(HEADER_HEIGHT + HEADER_HEIGHT + CELL_HEIGHT * (current_floor - 2)), width: CGFloat(ScreenWidth), height: CGFloat(RECT_RANGE))
        }
        
        let array: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: correctRect) ?? []
        
        if screen_y >= HEADER_HEIGHT {
            for attributes: UICollectionViewLayoutAttributes in array {
                let row: CGFloat = CGFloat(attributes.indexPath.row)
                if row < current_floor {
                    attributes.zIndex = 0
                    attributes.frame = CGRect(x: CGFloat(0), y: CGFloat((HEADER_HEIGHT - DRAG_INTERVAL) + DRAG_INTERVAL * row), width: CGFloat(ScreenWidth), height: CGFloat(CELL_CURRHEIGHT))
                    setEffectViewAlpha(1, for: attributes.indexPath)
                }
                else if row == current_floor {
                    attributes.zIndex = 1
                    attributes.frame = CGRect(x: CGFloat(0), y: CGFloat((HEADER_HEIGHT - DRAG_INTERVAL) + DRAG_INTERVAL * row), width: CGFloat(ScreenWidth), height: CGFloat(CELL_CURRHEIGHT))
                    setEffectViewAlpha(1, for: attributes.indexPath)
                }
                else if row == current_floor + 1 {
                    attributes.zIndex = 2
                    attributes.frame = CGRect(x: CGFloat(0), y: CGFloat(attributes.frame.origin.y + (current_floor - 1) * 70 - 70 * percent), width: CGFloat(ScreenWidth), height: CGFloat(CELL_HEIGHT + (CELL_CURRHEIGHT - CELL_HEIGHT) * percent))
                    setEffectViewAlpha(percent, for: attributes.indexPath)
                }
                else {
                    attributes.zIndex = 0
                    attributes.frame = CGRect(x: CGFloat(0), y: CGFloat(attributes.frame.origin.y + (current_floor - 1) * 70 + 70 * percent), width: CGFloat(ScreenWidth), height: CGFloat(CELL_HEIGHT))
                    setEffectViewAlpha(0, for: attributes.indexPath)
                }
                
                setImageViewOfItem((screen_y - attributes.frame.origin.y) / 568 * IMAGEVIEW_MOVE_DISTANCE, with: attributes.indexPath)
            }
        }
        else {
            for attributes: UICollectionViewLayoutAttributes in array {
                if attributes.indexPath.row > 1 {
                    setEffectViewAlpha(0, for: attributes.indexPath)
                }
                setImageViewOfItem((screen_y - attributes.frame.origin.y) / 568 * IMAGEVIEW_MOVE_DISTANCE, with: attributes.indexPath)
            }
        }
        
        self.delegate?.setEffectOfHead(screen_y)
        
        return array

    }
    
    /**
     *  设置CELL里imageView的位置偏移动画
     *
     *  @param distance
     *  @param indexpath
     */
    func setImageViewOfItem(_ distance: CGFloat, with indexpath: IndexPath) {
        let cell: GallerySliderCell? = (collectionView!.cellForItem(at: indexpath) as? GallerySliderCell)
        cell?.imageView?.frame = CGRect(x: CGFloat(0), y: CGFloat(IMAGEVIEW_ORIGIN_Y + distance), width: CGFloat(ScreenWidth), height: CGFloat((cell?.imageView?.frame.size.height)!))
    }
    
    func setEffectViewAlpha(_ percent: CGFloat, for indexPath: IndexPath) {
        let cell: GallerySliderCell? = (collectionView?.cellForItem(at: indexPath) as? GallerySliderCell)
        cell?.cellMaskView?.alpha = max((1 - percent) * 0.6, 0.2)
        cell?.title?.layer.transform = CATransform3DMakeScale(0.5 + 0.5 * percent, 0.5 + 0.5 * percent, 1)
        cell?.title?.center = CGPoint(x: CGFloat(UIScreen.main.bounds.size.width / 2), y: CGFloat(CELL_HEIGHT / 2 + (CELL_CURRHEIGHT - CELL_HEIGHT) / 2 * percent))
        cell?.desc?.layer.transform = CATransform3DMakeScale(0.5 + 0.5 * percent, 0.5 + 0.5 * percent, 1)
        cell?.desc?.center = CGPoint(x: CGFloat(UIScreen.main.bounds.size.width / 2), y: CGFloat(CELL_HEIGHT / 2 + (CELL_CURRHEIGHT - CELL_HEIGHT) / 2 * percent + 30))
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var destination: CGPoint
        var positionY: CGFloat
        let screen_y: CGFloat = collectionView?.contentOffset.y ?? 0
        var cc: CGFloat
        var count: CGFloat
        if screen_y < 0 {
            return proposedContentOffset
        }
        if velocity.y == 0 {
            //此情况可能由于拖拽不放手，停下时再放手的可能，所以加速度为0
            count = CGFloat(roundf((Float((proposedContentOffset.y - HEADER_HEIGHT) / DRAG_INTERVAL))) + Float(1))
            if count == 0 {
                positionY = 0
            }
            else {
                positionY = HEADER_HEIGHT + (count - 1) * DRAG_INTERVAL
            }
        }
        else {
            if velocity.y > 1 {
                cc = 1
            }
            else if velocity.y < -1 {
                cc = -1
            }
            else {
                cc = velocity.y
            }
            
            if velocity.y > 0 {
                count = CGFloat(ceilf((Float((screen_y + cc * DRAG_INTERVAL - HEADER_HEIGHT) / DRAG_INTERVAL))) + Float(1))
            }
            else {
                count = CGFloat(floorf((Float((screen_y + cc * DRAG_INTERVAL - HEADER_HEIGHT) / DRAG_INTERVAL))) + Float(1))
            }
            if count == 0 {
                positionY = 0
            }
            else {
                positionY = HEADER_HEIGHT + (count - 1) * DRAG_INTERVAL
            }
        }
        if positionY < 0 {
            positionY = 0
        }
        if positionY > collectionView!.contentSize.height - UIScreen.main.bounds.size.height {
            positionY = collectionView!.contentSize.height - UIScreen.main.bounds.size.height
        }
        destination = CGPoint(x: CGFloat(0), y: positionY)
        collectionView?.decelerationRate = 0.8
        return destination
    }
    
}
