//
//  ExpandableCellCollectionView.swift
//  ExpandableCell
//
//  Created by 김민성 on 3/23/25.
//

import os
import UIKit

/// A subclass of UICollectionView that is designed to work with `ExpandableCell` types.
///
/// This collection view requires cells that inherit from `ExpandableCell`. It provides built-in support
/// for cells that expand and fold with animation, and allows customization of the animation speed.
///
/// Additionally, `ExpandableCellCollectionView` provides simple layout configurations such as setting
/// insets and other layout properties for the collection view.
///
/// - Note: The cells registered to this collection view should be subclass of `ExpandableCell`.
///         Any other cell types will not work as expected.
public class ExpandableCellCollectionView: UICollectionView {
    
    public enum AnimationSpeed: CGFloat {
        
        /// assing this value to `animationSpeed` property if you don't want to apply animation when cell shrinks or expands.
        case none = 0.01
        
        /// slow speed when cell shrinks or expands. 0.7 seconds.
        case slow = 0.7
        
        /// medium speed when cell shrinks or expands. 0.5 seconds.
        case medium = 0.5
        
        /// fast speed when cell shrinks or expands. 0.3 seconds.
        case fast = 0.3
    }
    
    //MARK: - Public Properties
    
    /// animation speed when cell shrinks or expands.
    ///
    /// The default value is `.medium`(0.5 seconds).
    public var animationSpeed: AnimationSpeed = .medium
    
    // MARK: - Private Properties
    
    private let logger = OSLog(subsystem: "com.minsung.expandablecell", category: "Validation")
    private let cellSelectionOperationQueue = OperationQueue()
    private var sectionInset: UIEdgeInsets = .zero
    private var minimumLineSpacing: CGFloat = 0
    
    // MARK: -
    
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
        
        setupNotifications()
    }
    
    public convenience init(
        verticalInset: CGFloat,
        horizontalInset: CGFloat,
        minimumLineSpacing: CGFloat = .zero
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
        minimumLineSpacing: CGFloat = .zero
    ) {
        self.init(
            sectionInset: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset),
            minimumLineSpacing: minimumLineSpacing
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIContentSizeCategoryDidChange(_:)),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc func UIContentSizeCategoryDidChange(_ notification: Notification) {
        self.collectionViewLayout.invalidateLayout()
        self.performBatchUpdates(nil)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpandableCellCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let accCell  = cell as? ExpandableCell else {
            assertionFailure("A cell registered in AccCellCollectionView must inherit from AccCell.")
            os_log("A cell registered in AccCellCollectionView must inherit from AccCell.", type: .error)
            return
        }
        print(#function)
        // Setting cell's width.
        let horizontalSectionInset: CGFloat = sectionInset.left + sectionInset.right
        accCell.updateWidth(collectionView.bounds.width - horizontalSectionInset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView.cellForItem(at: indexPath) is ExpandableCell else {
            assertionFailure("A cell registered in AccCellCollectionView must inherit from AccCell.")
            os_log("A cell registered in AccCellCollectionView must inherit from AccCell.", type: .error)
            return true
        }
        let animator = UIViewPropertyAnimator(duration: animationSpeed.rawValue, dampingRatio: 1)
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
        guard collectionView.allowsMultipleSelection else { return false }
        let animator = UIViewPropertyAnimator(duration: animationSpeed.rawValue, dampingRatio: 1)
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
