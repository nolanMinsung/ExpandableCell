//
//  ExpandableCellCollectionViewDelegateInterceptor.swift
//  ExpandableCell
//
//  Created by 김민성 on 4/22/25.
//

import os
import UIKit


internal class ExpandableCellCollectionViewDelegateInterceptor: NSObject, UICollectionViewDelegate {
    
    weak var externalDelegate: UICollectionViewDelegate?
    
    init(externalDelegate: UICollectionViewDelegate?) {
        self.externalDelegate = externalDelegate
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        } else {
            return externalDelegate?.responds(to: aSelector) ?? false
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if externalDelegate?.responds(to: aSelector) == true {
            return externalDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let expandableCell  = cell as? ExpandableCell else {
            assertionFailure("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.")
            os_log("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.", type: .error)
            return
        }
        
        // Setting cell's width. width constraint's priority is 999.
        guard let collectionView = collectionView as? ExpandableCellCollectionView else { return }
        let horizontalContentInset = collectionView.contentInset.left + collectionView.contentInset.right
        let horizontalSectionInset = collectionView.sectionInset.left + collectionView.sectionInset.right
        let cellWidth = collectionView.bounds.width - horizontalContentInset - horizontalSectionInset
        
        expandableCell.updateWidth(cellWidth)
        self.externalDelegate?.collectionView?(collectionView, willDisplay: expandableCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView.cellForItem(at: indexPath) is ExpandableCell else {
            assertionFailure("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.")
            os_log("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.", type: .error)
            return true
        }
        guard let collectionView = collectionView as? ExpandableCellCollectionView else { return false }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            if !cell.isSelected {
                cell.applyExpansionState()
            } else {
                cell.applyCollapsingState()
            }
        }
        
        let animator = UIViewPropertyAnimator(duration: collectionView.animationSpeed.rawValue, dampingRatio: 1)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                if self.externalDelegate?.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? true {
                    collectionView.deselectItem(at: indexPath, animated: false)
                    self.externalDelegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
                }
            } else {
                if self.externalDelegate?.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? true {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    self.externalDelegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                }
            }
            collectionView.performBatchUpdates(nil)
        }
        
        collectionView.cellSelectionSerialQueue.async {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView.allowsMultipleSelection else { return false }
        guard let collectionView = collectionView as? ExpandableCellCollectionView else { return false }
        if self.externalDelegate?.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? true {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.applyCollapsingState()
            }
            
            let animator = UIViewPropertyAnimator(duration: collectionView.animationSpeed.rawValue, dampingRatio: 1)
            animator.addAnimations { [weak self] in
                collectionView.deselectItem(at: indexPath, animated: false)
                self?.externalDelegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
                collectionView.performBatchUpdates(nil)
            }
            
            collectionView.cellSelectionSerialQueue.async {
                DispatchQueue.main.async { animator.startAnimation() }
            }
        }
        return false
    }
    
}
