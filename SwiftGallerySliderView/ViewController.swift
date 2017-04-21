//
//  ViewController.swift
//  CollectionviewDemo
//
//  Created by 杨智晓 on 2017/4/19.
//  Copyright © 2017年 杨智晓. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    var data: [UIColor] = []
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<50 {
            data.append(UIColor.random)
        }
        initCollectionView()
    }

    func initCollectionView() {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let layout = GallerySliderLayout(collectionFrame: frame, maxHeight: 200, normalHeight: 100)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(GallerySliderCell.self, forCellWithReuseIdentifier: "GallerySliderCell")
        view.addSubview(collectionView)
        
        layout.onCellFrameChange = { [unowned self] attr, frame in
            self.collectionView.visibleCells.forEach({ (cell) in
                if let `cell` = cell as? GallerySliderCell {
                    cell.ajustCell(attr: attr, frame: frame)
                }
            })
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallerySliderCell", for: indexPath) as? GallerySliderCell
        cell?.backgroundColor = data[indexPath.row]
        cell?.titleLabel.text = "\(indexPath.row)"
        cell?.indexPath = indexPath
        return cell!
    }
    
}

extension Int {
    var random: Float {
        return Float(arc4random()).truncatingRemainder(dividingBy: Float(self))
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(colorLiteralRed: 255.random / 255,
                       green: 255.random / 255,
                       blue: 255.random / 255,
                       alpha: 1)
    }
}
