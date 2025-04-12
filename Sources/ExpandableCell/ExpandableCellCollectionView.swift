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
open class ExpandableCellCollectionView: UICollectionView {
    
    /// Animation Speed when cell expanding and collapsing.
    public enum AnimationSpeed: CGFloat {
        
        /// assing this value to `animationSpeed` property if you don't want to apply animation when cell shrinks or expands.
        case none = 0.01
        
        /// slow speed when cell expands or collapses. 0.7 seconds.
        case slow = 0.7
        
        /// medium speed when cell expands or collapses. 0.5 seconds.
        case medium = 0.5
        
        /// fast speed when cell expands or collapses. 0.3 seconds.
        case fast = 0.3
    }
    
    /// animation speed when cell shrinks or expands.
    ///
    /// The default value is `.medium`(0.5 seconds).
    public var animationSpeed: AnimationSpeed = .medium
    
    public override var allowsMultipleSelection: Bool {
        didSet {
            if !allowsMultipleSelection {
                deselectAll()
            }
        }
    }
    
    private let cellSelectionSerialQueue = DispatchQueue(label: "cellSelection") // serial queue
    private let sectionInset: UIEdgeInsets
    private let minimumLineSpacing: CGFloat
    
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
        
        setupNotifications()
        setupDelegates()
    }
    
    public init(sectionInsetInVertical vertical: CGFloat, horizontal: CGFloat, minimumLineSpacing: CGFloat) {
        self.sectionInset = .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        self.minimumLineSpacing = minimumLineSpacing
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        setupNotifications()
        setupDelegates()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var delegate: (any UICollectionViewDelegate)? {
        willSet {
            assert(newValue === self || newValue == nil,
            """
            🚫ExpandableCellCollectionView delegate must be self. 
            ❗️If you want to implement UICollectionViewDelegate method, 
            please implement it in your own subclass of ExpandableCellCollectionView.
            """)
        }
    }
    
    public func register<T: ExpandableCell>(_ cellClass: T.Type, forCellWithReuseIdentifier identifier: String) {
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    @available(*, unavailable, message: "Use register(_:forCellWithReuseIdentifier:) with ExpandableCell only.")
    override public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    @available(*, unavailable, message: "Use register(_:forCellWithReuseIdentifier:) with ExpandableCell only.")
    override public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        assertionFailure("Use `register(_:forCellWithReuseIdentifier:)` method to register cell for ExpandableCellCollectionView")
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIContentSizeCategoryDidChange(_:)),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    private func setupDelegates() {
        self.delegate = self
    }
    
    private func deselectAll(_ completion: ((Bool) -> Void)? = nil) {
        guard let selectedIndexPaths = indexPathsForSelectedItems else { return }
        selectedIndexPaths.forEach { deselectItem(at: $0, animated: false) }
        performBatchUpdates(nil) { isCompleted in
            completion?(isCompleted)
        }
    }
    
    @objc func UIContentSizeCategoryDidChange(_ notification: Notification) {
        // if system font size changes, collection view deselects all cells to avoid unexpected layout bug.
        deselectAll()
        self.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpandableCellCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let accCell  = cell as? ExpandableCell else {
            assertionFailure("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.")
            os_log("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.", type: .error)
            return
        }
        
        // Setting cell's width.
        let horizontalSectionInset: CGFloat = sectionInset.left + sectionInset.right
        accCell.updateWidth(collectionView.bounds.width - horizontalSectionInset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView.cellForItem(at: indexPath) is ExpandableCell else {
            assertionFailure("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.")
            os_log("A cell registered in ExpandableCellCollectionView must inherit from ExpandableCell.", type: .error)
            return true
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExpandableCell {
            if !cell.isSelected {
                cell.applyExpansionState()
            } else {
                cell.applyCollapsingState()
            }
        }
        
        let animator = UIViewPropertyAnimator(duration: animationSpeed.rawValue, dampingRatio: 1)
        animator.addAnimations { [weak self] in
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                collectionView.deselectItem(at: indexPath, animated: false)
                self?.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
            } else {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                self?.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
            }
            collectionView.performBatchUpdates(nil)
        }
        
        cellSelectionSerialQueue.async {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView.allowsMultipleSelection else { return false }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExpandableCell {
            cell.applyCollapsingState()
        }
        
        let animator = UIViewPropertyAnimator(duration: animationSpeed.rawValue, dampingRatio: 1)
        animator.addAnimations { [weak self] in
            collectionView.deselectItem(at: indexPath, animated: false)
            self?.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
            collectionView.performBatchUpdates(nil)
        }
        
        cellSelectionSerialQueue.async {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        return false
    }
    
}
