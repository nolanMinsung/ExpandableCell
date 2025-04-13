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
    
    private lazy var mainContentViewLeadingConstraint =
    mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    private lazy var mainContentViewTrailingConstraint =
    mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    private lazy var detailContentViewLeadingConstraint =
    detailContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    private lazy var detailContentViewTrailingConstraint =
    detailContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    
    private lazy var shrinkedBottomConstraint = mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var expandedBottomConstraint = detailContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    open override var isSelected: Bool {
        didSet { updateExpandingState() }
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
    
    /// Called in the animation block for cell expansion.
    ///
    /// This method is executed within the animation block when the cell expands.
    /// Override this method in a subclass to define custom expand animations.
    ///
    /// Calling `super` is not necessary.
    ///
    /// - Note: Since this method runs inside an animation block, any animatable changes made here will be animated.
    open func animateExpansion() { }
    
    /// Called in the animation block for cell collapsing.
    ///
    /// This method is executed within the animation block when the cell collapses.
    /// Override this method in a subclass to define custom collapse animations.
    ///
    /// Calling `super` is not necessary.
    ///
    /// - Note: Since this method runs inside an animation block, any animatable changes made here will be animated.
    open func animateCollapse() { }
    
    /// Called when cell expanding animation is about to start.
    ///
    /// Override this method in a subclass to immediately apply the expanded state without triggering any animations.
    /// It allows configuring the UI elements to match the expanded appearance.
    ///
    /// Calling `super` is not necessary.
    ///
    /// - Note: This method does not perform the expansion itself. It only updates the UI accordingly.
    open func applyExpansionState() { }
    
    /// Called when cell collapsing animation is about to start.
    ///
    /// Override this method in a subclass to immediately apply the collapsed state without triggering any animations.
    /// It allows configuring the UI elements to match the collapsed appearance.
    ///
    /// Calling `super` is not necessary.
    ///
    /// - Note: This method does not perform the collapse itself. It only updates the UI accordingly.
    open func applyCollapsingState() { }
    
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
        widthConstraint.priority = .init(999)
        widthConstraint.isActive = true
        
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        
        mainContentViewLeadingConstraint.priority = .init(999)
        mainContentViewTrailingConstraint.priority = .init(999)
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentViewLeadingConstraint,
            mainContentViewTrailingConstraint
        ])
        
        detailContentViewLeadingConstraint.priority = .init(999)
        detailContentViewTrailingConstraint.priority = .init(999)
        NSLayoutConstraint.activate([
            detailContentView.topAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            detailContentViewLeadingConstraint,
            detailContentViewTrailingConstraint
        ])
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
    }
    
    private func updateExpandingState() {
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        if isSelected {
            animateExpansion()
        } else {
            animateCollapse()
        }
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
    }
    
}

public extension ExpandableCell {
    
    /// Set and update cell's width.
    /// - Parameter width: new width to be updated.
    internal func updateWidth(_ width: CGFloat) {
        self.widthConstraint.constant = width
        updateExpandingState()
    }
    
}
