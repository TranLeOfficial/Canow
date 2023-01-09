//
//  CustomCollectionViewFlowLayout.swift
//  Canow
//
//  Created by hieplh2 on 10/12/2021.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    let activeDistance: CGFloat = 200
    var zoomFactor: CGFloat = 0.3
    
    // MARK: - Constructors
    init(itemSize: CGSize, minimumLineSpacing: CGFloat = 20, zoomFactor: CGFloat = 0.3) {
        super.init()
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.zoomFactor = zoomFactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func prepare() {
        super.prepare()
        self.setupUI()
    }
    
    // Zoom
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as? UICollectionViewLayoutAttributes ?? UICollectionViewLayoutAttributes() }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        let visibleAttributes = rectAttributes.filter { $0.frame.intersects(visibleRect) }
        
        // Keep the spacing between cells the same.
        // Each cell shifts the next cell by half of it's enlarged size.
        // Calculated separately for each direction.
        func adjustXPosition(_ toProcess: [UICollectionViewLayoutAttributes], direction: CGFloat, zoom: Bool = false) {
            var dx: CGFloat = 0
            
            for attributes in toProcess {
                let distance = visibleRect.midX - attributes.center.x
                attributes.frame.origin.x += dx
                
                if distance.magnitude < self.activeDistance {
                    let normalizedDistance = distance / self.activeDistance
                    let zoomAddition = self.zoomFactor * (1 - normalizedDistance.magnitude)
                    let widthAddition = attributes.frame.width * zoomAddition / 2
                    
                    dx = widthAddition * direction + dx
                    
                    if zoom {
                        let scale = 1 + zoomAddition
                        attributes.transform3D = CATransform3DMakeScale(scale, scale, 1)
                    }
                }
            }
        }
        
        // Adjust the x position first from left to right.
        // Then adjust the x position from right to left.
        // Lastly zoom the cells when they reach the center of the screen (zoom: true).
        adjustXPosition(visibleAttributes, direction: +1)
        adjustXPosition(visibleAttributes.reversed(), direction: -1, zoom: true)
        
        return rectAttributes
    }
    
    // Center
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        
        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView.frame.width,
                                height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
    
}

// MARK: - Methods
extension CustomCollectionViewFlowLayout {
    
    private func setupUI() {
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 16
        
        guard let collectionView = self.collectionView else { return }
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        self.sectionInset = UIEdgeInsets(top: verticalInsets,
                                         left: horizontalInsets,
                                         bottom: verticalInsets,
                                         right: horizontalInsets)
    }
    
}
