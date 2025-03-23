//
//  AccordionCollectionView.swift
//  AccordionCell
//
//  Created by 김민성 on 3/23/25.
//

import UIKit

//import Then

open class AccCellCollectionView: UICollectionView {
    
    private let cellSelectionOperationQueue = OperationQueue()
    
    var sectionInset: UIEdgeInsets = .zero
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    
    init(
        sectionInset: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = .zero,
        minimumInteritemSpacing: CGFloat = .zero
    ) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        self.delegate = self
    }
    
    convenience init(
        verticalInset: CGFloat,
        horizontalInset: CGFloat,
        minimumLineSpacing: CGFloat = .zero,
        minimumInteritemSpacing: CGFloat = .zero
    ) {
        self.init(
            sectionInset: UIEdgeInsets(top: verticalInset,
                                       left: horizontalInset,
                                       bottom: verticalInset,
                                       right: horizontalInset),
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
    }
    
    convenience init(
        inset: CGFloat,
        minimumLineSpacing: CGFloat = .zero,
        minimumInteritemSpacing: CGFloat = .zero
    ) {
        self.init(
            sectionInset: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset),
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AccCellCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard collectionView.cellForItem(at: indexPath) is AccCell else { return true }
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
        animator.addAnimations {
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                collectionView.deselectItem(at: indexPath, animated: false)
            } else {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
            collectionView.performBatchUpdates(nil)
        }
        
        let animationOperation = BlockOperation {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        
        cellSelectionOperationQueue.addOperation(animationOperation)
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        // deselect는 allowsMultipleSelection = true 인 경우에만 해당
        guard collectionView.allowsMultipleSelection else { return false }
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
        animator.addAnimations {
            collectionView.deselectItem(at: indexPath, animated: false)
            collectionView.performBatchUpdates(nil)
        }
        
        let animationOperation = BlockOperation {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        
        cellSelectionOperationQueue.addOperation(animationOperation)
        return false
    }
    
}
