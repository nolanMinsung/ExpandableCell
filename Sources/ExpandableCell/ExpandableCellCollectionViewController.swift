//
//  File.swift
//  ExpandableCell
//
//  Created by 김민성 on 3/25/25.
//

import UIKit

import os

open class ExpandableCellCollectionViewController: UIViewController {
    
    private let cellSelectionSerialQueue = DispatchQueue(label: "cellSelection") // serial queue
    private let logger = OSLog(subsystem: "com.minsung.expandablecell", category: "Validation")
    private var sectionInset: UIEdgeInsets
    private var minimumLineSpacing: CGFloat
    
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
    
    public let collectionView: ExpandableCellCollectionView
    
    public init(collectionView: ExpandableCellCollectionView) {
        self.collectionView = collectionView
        self.sectionInset = collectionView.sectionInset
        self.minimumLineSpacing = collectionView.minimumLineSpacing
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(sectionInset: UIEdgeInsets = .zero, minimumLineSpacing: CGFloat = .zero) {
        let collectionView = ExpandableCellCollectionView(sectionInset: sectionInset, minimumLineSpacing: minimumLineSpacing)
        self.init(collectionView: collectionView)
    }
    
    public convenience init(verticalInset: CGFloat, horizontalInset: CGFloat, minimumLineSpacing: CGFloat = .zero) {
        let insets = UIEdgeInsets(top: verticalInset,
                                  left: horizontalInset,
                                  bottom: verticalInset,
                                  right: horizontalInset)
        self.init(sectionInset: insets, minimumLineSpacing: minimumLineSpacing)
    }
    
    public convenience init(inset: CGFloat, minimumLineSpacing: CGFloat = .zero) {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        self.init(sectionInset: insets, minimumLineSpacing: minimumLineSpacing)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        view = collectionView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension ExpandableCellCollectionViewController: UICollectionViewDataSource {
    
    @available(iOS 6.0, *)
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView(collectionView, numberOfItemsInSection: section)
    }

    @available(iOS 8.0, *)
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.collectionView(collectionView, cellForItemAt: indexPath)
    }

    @available(iOS 6.0, *)
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.numberOfSections(in: collectionView)
    }

    @available(iOS 8.0, *)
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }

    @available(iOS 9.0, *)
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        self.collectionView(collectionView, canMoveItemAt: indexPath)
    }

    @available(iOS 9.0, *)
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpandableCellCollectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let accCell  = cell as? ExpandableCell else {
            assertionFailure("A cell registered in AccCellCollectionView must inherit from AccCell.")
            os_log("A cell registered in AccCellCollectionView must inherit from AccCell.", type: .error)
            return
        }
        
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
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExpandableCell {
            if !cell.isSelected {
                cell.applyExpansionState()
            } else {
                cell.applyCollapsingState()
            }
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
        animator.addAnimations {
            collectionView.deselectItem(at: indexPath, animated: false)
            collectionView.performBatchUpdates(nil)
        }
        
        cellSelectionSerialQueue.async {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        return false
    }
    
}
