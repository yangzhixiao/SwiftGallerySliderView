//
//  ViewController.swift
//  SwiftGallerySliderView
//
//  Created by 杨智晓 on 2017/4/18.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let CELL_HEIGHT: CGFloat = 100.0
let CELL_CURRHEIGHT: CGFloat = 240.0
let TITLE_HEIGHT: CGFloat = 40.0
let IMAGEVIEW_ORIGIN_Y: CGFloat = -30.0
let IMAGEVIEW_MOVE_DISTANCE: CGFloat = 160.0
let NAVIGATOR_LABEL_HEIGHT: CGFloat = 25.0
let NAVIGATOR_LABELCONTAINER_HEIGHT: CGFloat = 125.0
let SC_IMAGEVIEW_HEIGHT: CGFloat = 360.0
func RGBACOLOR(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: ((r) / 255.0), green: CGFloat((g) / 255.0), blue: CGFloat((b) / 255.0), alpha: CGFloat((a)))
}
let DRAG_INTERVAL: CGFloat = 170.0
let HEADER_HEIGHT: CGFloat = 00.0
let RECT_RANGE: CGFloat = 1000.0

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var galleryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }
    
    //生成滚动视图
    func initCollectionView() {
        let layout = GallerySliderLayout()
        layout.setContentSize(10)
        galleryCollectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(UIScreen.main.bounds.height)), collectionViewLayout: layout)
        galleryCollectionView.register(GallerySliderCell.self, forCellWithReuseIdentifier: "CELL")
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
//        galleryCollectionView.backgroundColor = UIColor(hex: 0xeeeeee)
        view.addSubview(galleryCollectionView)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: CGFloat(ScreenWidth), height: CGFloat(HEADER_HEIGHT))
        }
        else if indexPath.row == 1 {
            return CGSize(width: CGFloat(ScreenWidth), height: CGFloat(CELL_CURRHEIGHT))
        }
        else {
            return CGSize(width: CGFloat(ScreenWidth), height: CGFloat(CELL_HEIGHT))
        }
        
    }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? GallerySliderCell
        cell?.tag = indexPath.row
        cell?.setIndex(indexPath.row)
        cell?.reset()
        if indexPath.row == 0 {
            cell?.imageView?.image = nil
        }
        else {
            if indexPath.row == 1 {
                cell?.revisePositionAtFirstCell()
            }
            cell?.setNameLabel("珠江新城商圈")
            cell?.setDescLabel("距离1000米")
            let image = UIImage(named: "test.jpg")
            cell?.imageView?.image = image
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--------+++++ \(indexPath.row)")
    }
    
}

