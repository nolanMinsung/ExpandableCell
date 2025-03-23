//
//  AccordionCollectionView.swift
//  AccordionCell
//
//  Created by 김민성 on 3/23/25.
//

import UIKit

open class AccCellCollectionView: UICollectionView {
    
    private let cellSelectionOperationQueue = OperationQueue()
    private var sectionInset: UIEdgeInsets = .zero
    private var minimumLineSpacing: CGFloat = 0
    private var minimumInteritemSpacing: CGFloat = 0
    
    public init(
        sectionInset: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = .zero
    ) {
        self.sectionInset = sectionInset
        self.minimumLineSpacing = minimumLineSpacing
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        self.delegate = self
    }
    
    public convenience init(
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
            minimumLineSpacing: minimumLineSpacing
        )
    }
    
    public convenience init(
        inset: CGFloat,
        minimumLineSpacing: CGFloat = .zero,
        minimumInteritemSpacing: CGFloat = .zero
    ) {
        self.init(
            sectionInset: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset),
            minimumLineSpacing: minimumLineSpacing
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AccCellCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let accCell = cell as? AccCell else { return }
        let horizontalSectionInset: CGFloat = sectionInset.left + sectionInset.right
        accCell.updateWidth(collectionView.bounds.width - horizontalSectionInset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard collectionView.cellForItem(at: indexPath) is AccCell else {
            print("collectionView에 register된 cell이 AccCell이 아님")
            return true
        }
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
