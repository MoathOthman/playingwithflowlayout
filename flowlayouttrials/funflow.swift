//
//  funflow.swift
//  flowlayouttrials
//
//  Created by moath on 7/21/18.
//  Copyright © 2018 moath othman. All rights reserved.
//

import UIKit

class funflow: UICollectionViewFlowLayout {
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    var cellWidth: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        
        
        //        cellWidth = collection.frame.width - 80
        scrollDirection = .horizontal
        guard let collectionView = collectionView else { return }
        var cellHeight: CGFloat!
        let xInsets: CGFloat = 100
        let yInsets: CGFloat = 12
        
        // get size from delegate if the sizeForItem function is called.
        
        cellWidth = collectionView.frame.size.width - xInsets
        cellHeight = collectionView.frame.size.height - yInsets
        
        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        
        itemSize =  CGSize(width: cellWidth, height: cellHeight)
//        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let items = NSArray (array: super.layoutAttributesForElements(in: rect)!, copyItems: true)
        
        items.enumerateObjects(using: { (object, index, stop) -> Void in
            let attributes = object as! UICollectionViewLayoutAttributes
            
            self.updateCellAttributes(attributes,
                                      count: items.count,
                                      all: items as! [UICollectionViewLayoutAttributes])
        })
        return items as? [UICollectionViewLayoutAttributes]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let pageWidth = cellWidth + self.minimumInteritemSpacing
        let approximatePage = self.collectionView!.contentOffset.x/pageWidth
        
        // Determine the current page based on velocity.
        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
        
        // Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3
        
        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
        print("flicked: ", self.collectionView!.contentInset.left, pageWidth)
        // Calculate newVerticalOffset.
        let newVerticalOffset = ((currentPage) * pageWidth)
        
        print("ojj",CGPoint(x: newVerticalOffset, y: proposedContentOffset.y), velocity.x)
        return CGPoint(x: newVerticalOffset , y: proposedContentOffset.y)
    }
    let leftCardShowingPartWidth: CGFloat = 20
    fileprivate func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes, count: Int, all: [UICollectionViewLayoutAttributes]) {
        let minY = collectionView!.bounds.minX + collectionView!.contentInset.left
        let maxY =  attributes.frame.origin.x
        
        let finalY = min(minY, maxY) + leftCardShowingPartWidth
        print(finalY, attributes.indexPath.row, maxY, minY)
        var origin = attributes.frame.origin
        let deltaY = (finalY - origin.x) / attributes.frame.width
        let scale = 1 + deltaY * 0.05
        origin.x = finalY
        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
        attributes.zIndex = count - attributes.indexPath.row

        let offset = collectionView!.contentOffset.x
//        return
        // check if the cell is visisble
        if attributes.frame.origin.x > offset {
            // on screen
            // count three
            // get last attribute below offset
            let veryfirst = self.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))!
            let last = all.filter({$0.frame.origin.x < offset}).last ?? veryfirst
            var firstNextRow = last.indexPath.row + 1
            // check if attribute is after latest , shrink the width
            // check if attrine is after latest + 1 , shrink less
            // shifting the dx is causing jittering
            if veryfirst.indexPath.row == 0 && last.indexPath.row == 0 {
                firstNextRow = 0
            }
            if attributes.indexPath.row == firstNextRow {
                cardTranslation(attributes: attributes, dx: 20, yscale: scale)
//                origin.x += 20
            }else if attributes.indexPath.row == firstNextRow + 1 {
                cardTranslation(attributes: attributes, dx: 30, yscale: scale - 0.05)
//                origin.x += 30

            } else if attributes.indexPath.row > last.indexPath.row {
                cardTranslation(attributes: attributes, dx: 40, yscale: scale - 0.1)
//                origin.x += 40

            } else {
                cardTranslation(attributes: attributes, dx: 0, yscale: scale)
//                origin.x += 20

            }
        } else {
            cardTranslation(attributes: attributes, dx: 20, yscale: 1)
        }
//        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)


        //        print("or", attributes.indexPath.row,  attributes.frame.origin, collectionView!.contentOffset.x)
    }
    
    func cardTranslation(attributes: UICollectionViewLayoutAttributes, dx: CGFloat, yscale: CGFloat)  {
        let translation = CGAffineTransform(translationX: 0, y: 0.0)
        let scaleTranslation = CGAffineTransform(scaleX: 1, y: yscale)
        attributes.transform = translation.concatenating(scaleTranslation)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func currentPage() -> Int {
        let pageWidth = cellWidth + self.minimumInteritemSpacing
        let approximatePage = self.collectionView!.contentOffset.x/pageWidth
        
        let currentPage = floor(approximatePage)
        return Int(currentPage)
    }
}
