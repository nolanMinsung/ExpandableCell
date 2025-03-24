// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

/// `ExpandableCell` is an abstract subclass of `UICollectionViewCell` that provides
/// expanding functionality.
///
/// This class is a base class.
/// - Note: must be registered
///   with a subclass of `ExpandableCellCollectionView` for proper functionality.
open class ExpandableCell: UICollectionViewCell {
    
    //MARK: - Private Properties
    
    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
    
    private lazy var shrinkedBottomConstraint = mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var expandedBottomConstraint = detailContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    open override var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    //MARK: - UI Properties (Private)
    
    /// A content view that is always visible, regardless of whether the cell is collapsed (shrinked) or expanded.
    ///
    /// Use this view for content that should always be visible, such as a brief description or a title.
    /// You can add subviews to this view to display essential content.
    public let mainContentView = UIView()
    
    /// A view that is hidden when the cell is collapsed and becomes visible when the cell is expanded.
    ///
    /// Use this view for content that should be optionally visible, such as a detailed description or additional information.
    /// You can add subviews to this view to display content that can be toggled.
    public let detailContentView = UIView()
    
    //MARK: - Life Cycle
    
    /// Initializes an `AccCell` instance.
    ///
    /// - Important: When subclassing `AccCell`, you **must** call `super.init()`
    ///   in your initializer to ensure proper setup.
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViewHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

private extension ExpandableCell {
    
    //MARK: - Private Func
    
    private func setupViewHierarchy() {
        contentView.addSubview(mainContentView)
        contentView.addSubview(detailContentView)
    }
    
    private func setupStyle() {
        contentView.clipsToBounds = true
        mainContentView.clipsToBounds = true
        detailContentView.clipsToBounds = true
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailContentView.topAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
    }
    
    private func setAppearance() {
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
    }
    
}

public extension ExpandableCell {
    
    
    /// Set and update cell's width.
    /// - Parameter width: new width to be updated.
    internal func updateWidth(_ width: CGFloat) {
        self.widthConstraint.constant = width
        setAppearance()
    }
    
}
