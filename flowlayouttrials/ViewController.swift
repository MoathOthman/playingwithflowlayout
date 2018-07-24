//
//  ViewController.swift
//  flowlayouttrials
//
//  Created by moath on 7/21/18.
//  Copyright © 2018 moath othman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionview: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
//        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 8, height: 0)
        cell.layer.shadowOpacity = 0.3
        let imagevies = cell.contentView.viewWithTag(2) as! UIImageView
        if indexPath.row % 3 == 0 {
            imagevies.image = #imageLiteral(resourceName: "Junk-Food-PNG-File.png")
        } else if indexPath.row % 3 == 2 {
            imagevies.image = #imageLiteral(resourceName: "receta-hamburguesa-big-mac-D_NQ_NP_331711-MLV20609757976_022016-F.jpg")
        } else {
            imagevies.image = #imageLiteral(resourceName: "X-TUDO-Cópia-600x600.png")
        }
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.9
    }
}

