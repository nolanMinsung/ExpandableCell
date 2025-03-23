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
    
    init() {
//        let collectionViewHorizontalInset: CGFloat = 24
        let collectionViewHorizontalInset: CGFloat = 0
        let collectionViewVerticalInset: CGFloat = 20
        let itemWidth = floor(UIScreen.main.bounds.width - collectionViewHorizontalInset * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .init(
            top: collectionViewVerticalInset,
            left: collectionViewHorizontalInset,
            bottom: 40,
            right: collectionViewHorizontalInset
        )
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 100
//        flowLayout.estimatedItemSize = CGSize(width: itemWidth, height: 125)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        setupStyle()
        setupDelegates()
    }
    
    override internal init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupStyle()
        setupDelegates()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStyle() {
        backgroundColor = .darkGray
        indicatorStyle = .black
        contentInsetAdjustmentBehavior = .never
        scrollIndicatorInsets = .zero
        allowsMultipleSelection = true
    }
    
    func setupDelegates() {
        self.delegate = self
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
