//
//  ExpandableCellCollectionView.swift
//  ExpandableCell
//
//  Created by 김민성 on 3/23/25.
//

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
    
    internal let cellSelectionSerialQueue = DispatchQueue(label: "cellSelection") // serial queue
    
    private(set) public var sectionInset: UIEdgeInsets
    private let minimumLineSpacing: CGFloat
    
    private var delegateInterceptor = ExpandableCellCollectionViewDelegateInterceptor(externalDelegate: nil)
    
    public init(
        contentInset: UIEdgeInsets = .zero,
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
        self.contentInset = contentInset
        
        setupNotifications()
        super.delegate = delegateInterceptor
    }
    
    public init(
        horizontalContentInset: CGFloat = .zero,
        verticalContentInset: CGFloat = .zero,
        horizontalSectionInset: CGFloat = .zero,
        verticalSectionInset: CGFloat = .zero,
        minimumLineSpacing: CGFloat = .zero
    ) {
        self.sectionInset = .init(
            top: verticalSectionInset,
            left: horizontalSectionInset,
            bottom: verticalSectionInset,
            right: horizontalSectionInset
        )
        self.minimumLineSpacing = minimumLineSpacing
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.contentInset = .init(
            top: verticalContentInset,
            left: horizontalContentInset,
            bottom: verticalContentInset,
            right: horizontalContentInset
        )
        setupNotifications()
        super.delegate = delegateInterceptor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var delegate: (any UICollectionViewDelegate)? {
        didSet {
            delegateInterceptor.externalDelegate = delegate
            super.delegate = delegateInterceptor
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
    
    private func deselectAll(_ completion: ((Bool) -> Void)? = nil) {
        guard let selectedIndexPaths = indexPathsForSelectedItems else { return }
        selectedIndexPaths.forEach { deselectItem(at: $0, animated: false) }
        performBatchUpdates(nil) { isCompleted in
            completion?(isCompleted)
        }
    }
    
    @objc private func UIContentSizeCategoryDidChange(_ notification: Notification) {
        // if system font size changes, collection view deselects all cells to avoid unexpected layout bug.
        deselectAll()
        self.collectionViewLayout.invalidateLayout()
    }
    
}

// overriding UICollectionView's Instance methods/properties
extension ExpandableCellCollectionView {
    
    /// Gets the expandable cell object at the index path you specify.
    /// - Parameter indexPath: The index path that specifies the section and item number of the expandable cell.
    /// - Returns: The cell at the given index path if it is an instance of `ExpandableCell`; otherwise, `nil`.
    open override func cellForItem(at indexPath: IndexPath) -> ExpandableCell? {
        return (super.cellForItem(at: indexPath) as? ExpandableCell) ?? nil
    }
    
    /// An array of visible cells that are cast to `ExpandableCell`.
    public var visibleExpandableCells: [ExpandableCell] {
        return super.visibleCells.map({ $0 as! ExpandableCell })
    }
    
}
