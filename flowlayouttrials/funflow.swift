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
         guard let collectionView = collectionView else {
            return
        }
         var cellHeight: CGFloat!
        let xInsets: CGFloat = 20 +  0 + 20
        let yInsets: CGFloat = 12
        
        // get size from delegate if the sizeForItem function is called.
        
        cellWidth = collectionView.frame.size.width - xInsets
        cellHeight = collectionView.frame.size.height - yInsets
        
        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        
         itemSize =  CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let items = NSArray (array: super.layoutAttributesForElements(in: rect)!, copyItems: true)
        
        items.enumerateObjects(using: { (object, index, stop) -> Void in
            let attributes = object as! UICollectionViewLayoutAttributes
            
            self.updateCellAttributes(attributes)
        })
        return items as? [UICollectionViewLayoutAttributes]
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let nextIndexPath = IndexPath(row: itemIndexPath.row + 1, section: itemIndexPath.section)
        let nextAttr = self.layoutAttributesForItem(at: nextIndexPath)
        nextAttr?.zIndex = nextIndexPath.row
        
        // attributes for swiping card away
        let attr = self.layoutAttributesForItem(at: itemIndexPath)
        
        return attr
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
        
        // Calculate newVerticalOffset.
        let newVerticalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left

        print(CGPoint(x: newVerticalOffset, y: proposedContentOffset.y), velocity.x)
        return CGPoint(x: newVerticalOffset, y: proposedContentOffset.y)
    }
    
    fileprivate func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        let minY = collectionView!.bounds.minX + collectionView!.contentInset.left
        let maxY = attributes.frame.origin.x
        
        let finalY = max(minY, maxY)
        var origin = attributes.frame.origin
        let deltaY = (finalY - origin.x) / attributes.frame.width
        let scale = 1 - deltaY * 0.05
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        origin.x = finalY
        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
        attributes.zIndex = attributes.indexPath.row
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
