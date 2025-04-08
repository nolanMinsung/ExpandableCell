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
    
    //MARK: - Public Properties
    
    public override var allowsMultipleSelection: Bool {
        didSet {
            if !allowsMultipleSelection {
                deselectAll()
            }
        }
    }
    
    // MARK: - Private Properties
    
    internal var sectionInset: UIEdgeInsets = .zero
    internal var minimumLineSpacing: CGFloat = 0
    
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
        
        setupNotifications()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
