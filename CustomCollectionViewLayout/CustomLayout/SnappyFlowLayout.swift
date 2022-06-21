//
//  SnappyFlowLayout.swift
//  CustomCollectionViewLayout
//
//  Created by Simran Preet Narang on 2022-06-20.
//

import UIKit

class SnappyFlowLayout: UICollectionViewFlowLayout {
  let activeDistance: CGFloat = 200
  let zoomFactor: CGFloat = 0.3
 
  override init() {
    super.init()
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    scrollDirection = .horizontal
    minimumLineSpacing = 0
  }
  
  private func getCollectionView() -> UICollectionView {
    guard let collectionView = collectionView else {
      fatalError("CollectionView is not present")
    }
    return collectionView
  }
  
  override func prepare() {
    let collectionView = getCollectionView()
    let width = collectionView.frame.width * 0.6
    let height = collectionView.frame.height * 0.6
    itemSize = CGSize(width: width, height: height)
    
    let verticalInset = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - height) / 2
    let horizontalInset = (collectionView.frame.width - collectionView.adjustedContentInset.left - collectionView.adjustedContentInset.right - width) / 2
    sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    super.prepare()
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let collectionView = getCollectionView()
      
      print("ℹ️", rect)
    
    // TODO remove force unwrapping
    let rectAttrs = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
    let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
    
    for attribute in rectAttrs where attribute.frame.intersects(visibleRect) {
      let distance = visibleRect.midX - attribute.center.x
      let normalizedDistance = distance / activeDistance
      
      if distance.magnitude < activeDistance {
        let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
        attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
        attribute.zIndex = Int(zoom.rounded())
      }
    }
    
    return rectAttrs
  }
  
//  // Snapping Behavior
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    let collectionView = getCollectionView()

    let targetRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)

    guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else {
      return .zero
    }

    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
    let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

    for layoutAttribute in rectAttributes {
      let itemHorizontalCenter = layoutAttribute.center.x
      if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
        offsetAdjustment = itemHorizontalCenter - horizontalCenter
      }
    }
      print("❌", collectionView.contentSize, (proposedContentOffset.x + offsetAdjustment), (collectionView.contentSize.width / (proposedContentOffset.x)))
    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
    let collectionView = getCollectionView()
    let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
    context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView.bounds.size
    return context
  }
}
