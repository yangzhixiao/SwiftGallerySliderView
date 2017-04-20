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
let keyWindow = UIApplication.shared.delegate!.window!!

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }

    func initCollectionView() {
        let layout = PhotoLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        cell?.backgroundColor = UIColor.random
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
