////
////  funflow.swift
////  flowlayouttrials
////
////  Created by moath on 7/21/18.
////  Copyright © 2018 moath othman. All rights reserved.
////
//
//import UIKit
//
//class funflow: UICollectionViewFlowLayout {
//
//    fileprivate var cache = [UICollectionViewLayoutAttributes]()
//    var cellWidth: CGFloat = 0.0
//    override func prepare() {
//        super.prepare()
//
//        guard cache.isEmpty == true, let collection = collectionView else {
//            return
//        }
//        cellWidth = collection.frame.width
//        scrollDirection = .horizontal
//        itemSize = CGSize(width: cellWidth , height: 400)
//        minimumInteritemSpacing = 0
//        sectionInset = .zero
//
//        let w = 200
//        let itemscount = collection.numberOfItems(inSection: 0)
//        for n in 0..<itemscount {
//            let index = IndexPath(item: n, section: 0)
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
//            let origin = CGPoint(x: w * n, y: Int(0))
//            let frame = CGRect(origin: origin, size: itemSize)
//            attributes.frame = frame.offsetBy(dx: 0, dy: 0)
//            attributes.transform = CGAffineTransform(scaleX: 0.9, y: 1)
//            attributes.zIndex = itemscount - attributes.indexPath.row
//
//            cache.append(attributes)
//        }
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visible = [UICollectionViewLayoutAttributes]()
//        for item in cache {
//            if item.frame.intersects(rect) {
//                visible.append(item)
//            }
//        }
//        return visible
//    }
//
//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//        let nextIndexPath = IndexPath(row: itemIndexPath.row + 1, section: itemIndexPath.section)
//        let nextAttr = self.layoutAttributesForItem(at: nextIndexPath)
//        nextAttr?.zIndex = nextIndexPath.row
//
//        // attributes for swiping card away
//        let attr = self.layoutAttributesForItem(at: itemIndexPath)
//
//        return attr
//    }
//
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        let pageWidth = cellWidth + self.minimumInteritemSpacing
//        let approximatePage = self.collectionView!.contentOffset.x/pageWidth
//
//        // Determine the current page based on velocity.
//        let currentPage = (velocity.y < 0.0) ? floor(approximatePage) : ceil(approximatePage)
//
//        // Create custom flickVelocity.
//        let flickVelocity = velocity.y * 0.3
//
//        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
//        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
//        
//        // Calculate newVerticalOffset.
//        let newVerticalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left
//
//        print(CGPoint(x: newVerticalOffset, y: proposedContentOffset.y))
//        return CGPoint(x: newVerticalOffset, y: proposedContentOffset.y)
//    }
//
//    //    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    //        let item = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//    //        item.transform = CGAffineTransform(scaleX: 1.4, y: 1.0)
//    //        return item
//    //    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return false
//    }
//    //    override var collectionViewContentSize: CGSize {
//    //        return CGSize(width: 1000, height: 500)
//    //    }
//}
